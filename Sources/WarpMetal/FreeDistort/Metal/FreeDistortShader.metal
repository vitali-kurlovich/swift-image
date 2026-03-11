//
//  Created by Vitali Kurlovich on 4.01.26.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>

using namespace metal;

inline static float2 convertToPosition(float4 bounds, float2 uv) {
    float width = bounds.z;
    float height = bounds.w;
    
    float x = bounds.x + uv.x * width;
    float y = bounds.y + uv.y * height;
    return float2(x, y);
}

inline static float2 freeDistortUV(float2 position, float2 p0, float2 p1, float2 p2, float2 p3) {
    
    const float epsilon = 0.0000001;
    const float px = position.x, py = position.y;
    
    const float x0 = p0.x, y0 = p0.y;
    const float x1 = p1.x, y1 = p1.y;
    const float x2 = p2.x, y2 = p2.y;
    const float x3 = p3.x, y3 = p3.y;
    
    const float dx01 = x0 - x1, dy01 = y0 - y1;
    const float dx03 = x0 - x3, dy03 = y0 - y3;
    const float dx12 = x1 - x2, dy12 = y1 - y2;
    const float dy13 = y1 - y3;
    const float dx23 = x2 - x3, dy23 = y2 - y3;
    
    const float DU = dx23 * dy01 - dx01 * dy23;
    const float DV = dx03 * dy12 - dx12 * dy03;
    
    const bool isUParallel = abs(DU) <= epsilon;
    const bool isVParallel = abs(DV) <= epsilon;
    
    const bool isAffine = isUParallel && isVParallel;
    
    if (isAffine) {
        const float divider = dy13 * x0 - dy03 * x1 + dy01 * x3;
        
        if (abs(divider) <= epsilon) {
            return float2(0.5, 0.5);
        }
        
        const float u = dx03 * py - dy03 * px + x3 * y0 - x0 * y3;
        const float v = dy01 * px - dx01 * py - x1 * y0 + x0 * y1;
        
        return float2(u, v) * (1/divider);
    }
    
    const float PD = py * (dx01 + dx23) - px * (dy01 + dy23);
    
    // (dx01 + dx23) py - px (dy01 + dy23) - x2 y0 + x3 (dy01 + y0) + x0 (dy23 - y3) + x1 y3 -> PP
    const float PP = PD - x2 * y0 + x3 * (dy01 + y0) + x0 * (dy23 - y3) + x1 * y3;
    
    // 4 (dx01 dy23 + dy01 (-x2 + x3)) (dy03 px - dx03 py - x3 y0 + x0 y3) -> AA
    
    const float AA = 4 * ( dx01 * dy23 - dx23 * dy01) * (dy03 * px - dx03 * py - x3 * y0 + x0 * y3);
    
    // Sqrt[AA + PP^2] -> SS
    float SS = AA + PP * PP;
    
    if (abs(SS) <= epsilon ) {
        SS = 0;
    } else {
        SS = sqrt(SS);
    }
    
    // PD - x2 y0 + x3 (dy01 + y0) + x0 (dy23 - y3) + x1 y3 -> BB
    const float BB = PD - x2 * y0 + x3 * (dy01 + y0) + x0 * (dy23 - y3) + x1 * y3;
    
    // PD + (dx12 + x1) y0 + x3 y1 - x0 (dy12 + y1) - x1 y3 -> EE
    const float EE = PD + (dx12 + x1) * y0 + x3 * y1 - x0 * (dy12 + y1) - x1 * y3;
    
    const float CN = px * (dy01 + dy23) - py * (dx01 + dx23) + x2 * y0;
    
    
    const float CC = CN - x1 * (dy03 + y0) - x3 * y1 + x0 * (dy12 + y1);
    
    const float NN =  CN - x3 * (dy01 + y0) - x0 * (dy23 - y3) - x1 * y3;
    
    
    // U -> -((BB + SS)/(2 DU))
    const float ul = -((BB + SS) / (2 * DU));
    // V -> (CC + SS)/(2 DV)
    const float vl = (CC + SS) / (2 * DV);
    
    if (ul >= 0 && ul <= 1 && vl >= 0 && vl <= 1) {
        return float2( ul, vl);
    }
    
    // U -> (NN + SS)/(2 DU)
    const float ur = (NN + SS) / (2 * DU);
    
    // V -> -(EE + SS)/(2 DVR)
    const float vr = (EE + SS) / (-2 * DV);
    
    return float2(ur, vr); //float2(ur, vr);
}

inline static bool inNormalRange(float2 uv ) {
    const float epsilon = 0.0000001;
    const float min = -epsilon;
    const float max = 1.0 + epsilon;
    
    return (uv.x >= min) && (uv.x <= max) && (uv.y >= min) &&  (uv.y <= max);
}


[[ stitchable ]] half4 freeDistortWarp(float2 position, SwiftUI::Layer layer,
                                       float4 boundingRect,
                                       float2 p0, float2 p1, float2 p2, float2 p3
                                       ) {
    
    const float2 uv = freeDistortUV(position, p0, p1, p2, p3);
    
    const float2 pos = convertToPosition(boundingRect, uv);
   
    return layer.sample(pos);
}

