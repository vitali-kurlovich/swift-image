//
//  File.metal
//  swift-mathkit
//
//  Created by Vitali Kurlovich on 4.01.26.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;


float2 convertToPosition(float4 bounds, float2 uv) {
    float width = bounds.z;
    float height = bounds.w;
    
    float x = bounds.x + uv.x * width;
    float y = bounds.y + uv.y * height;
    return float2(x, y);
}

float2 uv_controlPointsTransform(float2 position, float2 p0, float2 p1, float2 p2, float2 p3) {
    
    float px = position.x, py = position.y;
    
    float x0 = p0.x, y0 = p0.y;
    float x1 = p1.x, y1 = p1.y;
    float x2 = p2.x, y2 = p2.y;
    float x3 = p3.x, y3 = p3.y;
    
    float dx01 = x0 - x1, dy01 = y0 - y1;
    float dx03 = x0 - x3, dy03 = y0 - y3;
    float dx12 = x1 - x2, dy12 = y1 - y2;
    float dy13 = y1 - y3;
    float dx23 = x2 - x3, dy23 = y2 - y3;
    
    float DU = dx23 * dy01 - dx01 * dy23;
    float DV = dx03 * dy12 - dx12 * dy03;
    
    if (abs(DU) <= 0.0000001) {
        float divider = dy13 * x0 - dy03 * x1 + dy01 * x3;
        
        float u = dx03 * py - dy03 * px + x3 * y0 - x0 * y3;
        float v = dy01 * px - dx01 * py - x1 * y0 + x0 * y1;
        
        return float2( u / divider,  v / divider);
    }
        
    float PD = py * (dx01 + dx23) - px * (dy01 + dy23);
    
    // (dx01 + dx23) py - px (dy01 + dy23) - x2 y0 + x3 (dy01 + y0) + x0 (dy23 - y3) + x1 y3 -> PP
    float PP = PD - x2 * y0 + x3 * (dy01 + y0) + x0 * (dy23 - y3) + x1 * y3;
    
    // 4 (dx01 dy23 + dy01 (-x2 + x3)) (dy03 px - dx03 py - x3 y0 + x0 y3) -> AA
    
    float AA = 4 * ( dx01 * dy23 - dx23 * dy01) * (dy03 * px - dx03 * py - x3 * y0 + x0 * y3);
    
    // Sqrt[AA + PP^2] -> SS
    float SS = sqrt( AA + PP * PP );
    
    
    // PD - x2 y0 + x3 (dy01 + y0) + x0 (dy23 - y3) + x1 y3 -> BB
    float BB = PD - x2 * y0 + x3 * (dy01 + y0) + x0 * (dy23 - y3) + x1 * y3;
    
    // PD + (dx12 + x1) y0 + x3 y1 - x0 (dy12 + y1) - x1 y3 -> EE
    float EE = PD + (dx12 + x1) * y0 + x3 * y1 - x0 * (dy12 + y1) - x1 * y3;
    
    float CN = px * (dy01 + dy23) - py * (dx01 + dx23) + x2 * y0;
    
    
    float CC = CN - x1 * (dy03 + y0) - x3 * y1 + x0 * (dy12 + y1);
    
    float NN =  CN - x3 * (dy01 + y0) - x0 * (dy23 - y3) - x1 * y3;
    
    
    // U -> -((BB + SS)/(2 DU))
    float ul = -((BB + SS) / (2 * DU));
    // V -> (CC + SS)/(2 DV)
    float vl = (CC + SS) / (2 * DV);
    
    if (ul >= 0 && ul <= 1 && vl >= 0 && vl <= 1) {
        return float2( ul, vl);
    }
    
    // U -> (NN + SS)/(2 DU)
    float ur = (NN + SS) / (2 * DU);

    // V -> -(EE + SS)/(2 DVR)
    float vr = (EE + SS) / (-2 * DV);
    
    
    
    return float2(ur, vr); //float2(ur, vr);
}

[[ stitchable ]] half4 controlPointsTransform(
 float2 position,
 SwiftUI::Layer layer,
 float4 boundingRect,
 float2 p0, float2 p1, float2 p2, float2 p3
 ) {
    
    float2 uv = uv_controlPointsTransform(position, p0, p1, p2, p3);
    

   float2 pos = convertToPosition(boundingRect, uv);
   
    half4 currentColor = layer.sample(pos);
    return currentColor;

    
    return half4(0.2, 0.0, 0.5, 1.0);

}

