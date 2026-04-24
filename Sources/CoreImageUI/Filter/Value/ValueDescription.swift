//
//  ValueDescription.swift
//  swift-image
//
//  Created by Vitali Kurlovich on 26.03.2026.
//

import CoreImage

protocol ValueDescription {
    associatedtype Value

    var attribute: FilterAttribute { get }
}

extension ValueDescription {
    var type: FilterAttributeType {
        attribute.type
    }

    var displayName: String {
        attribute.displayName
    }

    var localizedDescription: String {
        attribute.localizedDescription
    }
}

extension ValueDescription where Value == Float {
    var `default`: Value {
        (attribute[kCIAttributeDefault] as? NSNumber)?.floatValue ?? 0
    }

    var identity: Value? {
        (attribute[kCIAttributeIdentity] as? NSNumber)?.floatValue
    }

    var min: Value? {
        (attribute[kCIAttributeMin] as? NSNumber)?.floatValue
    }

    var max: Value? {
        (attribute[kCIAttributeMax] as? NSNumber)?.floatValue
    }

    var range: ClosedRange<Value>? {
        guard let min, let max else {
            return nil
        }
        return min ... max
    }

    var slider: ClosedRange<Value>? {
        guard let sliderMin = (attribute[kCIAttributeSliderMin] as? NSNumber)?.floatValue,
              let sliderMax = (attribute[kCIAttributeSliderMax] as? NSNumber)?.floatValue
        else {
            return nil
        }

        return sliderMin ... sliderMax
    }
}

extension ValueDescription where Value == Int {
    var `default`: Value {
        (attribute[kCIAttributeDefault] as? NSNumber)?.intValue ?? 0
    }

    var identity: Value? {
        (attribute[kCIAttributeIdentity] as? NSNumber)?.intValue
    }

    var min: Value? {
        (attribute[kCIAttributeMin] as? NSNumber)?.intValue
    }

    var max: Value? {
        (attribute[kCIAttributeMax] as? NSNumber)?.intValue
    }

    var range: ClosedRange<Value>? {
        guard let min, let max else {
            return nil
        }
        return min ... max
    }

    var slider: ClosedRange<Value>? {
        guard let sliderMin = (attribute[kCIAttributeSliderMin] as? NSNumber)?.intValue,
              let sliderMax = (attribute[kCIAttributeSliderMax] as? NSNumber)?.intValue
        else {
            return nil
        }

        return sliderMin ... sliderMax
    }
}

extension ValueDescription where Value == UInt {
    var `default`: Value {
        (attribute[kCIAttributeDefault] as? NSNumber)?.uintValue ?? 0
    }

    var identity: Value? {
        (attribute[kCIAttributeIdentity] as? NSNumber)?.uintValue
    }

    var min: Value? {
        (attribute[kCIAttributeMin] as? NSNumber)?.uintValue
    }

    var max: Value? {
        (attribute[kCIAttributeMax] as? NSNumber)?.uintValue
    }

    var range: ClosedRange<Value>? {
        guard let min, let max else {
            return nil
        }
        return min ... max
    }

    var slider: ClosedRange<Value>? {
        guard let sliderMin = (attribute[kCIAttributeSliderMin] as? NSNumber)?.uintValue,
              let sliderMax = (attribute[kCIAttributeSliderMax] as? NSNumber)?.uintValue
        else {
            return nil
        }

        return sliderMin ... sliderMax
    }
}

extension ValueDescription where Value == Bool {
    var `default`: Value {
        (attribute[kCIAttributeDefault] as? NSNumber)?.boolValue ?? false
    }

    var identity: Value? {
        (attribute[kCIAttributeIdentity] as? NSNumber)?.boolValue
    }
}

extension ValueDescription where Value == CGPoint {
    var `default`: Value {
        (attribute[kCIAttributeDefault] as? CIVector)?.cgPointValue ?? .zero
    }

    var identity: Value? {
        (attribute[kCIAttributeIdentity] as? CIVector)?.cgPointValue
    }
}

extension ValueDescription where Value == CGRect {
    var `default`: Value {
        guard let value = attribute[kCIAttributeDefault] else { return .zero }

        if attribute.className == "NSValue" {
            #if os(macOS)
                if let rect = (value as? NSValue)?.rectValue {
                    return CGRect(x: rect.minX, y: rect.minY, width: rect.width, height: rect.height)
                }
            #endif

            #if os(iOS)

                return (value as? NSValue)?.cgRectValue ?? .zero
            #endif
        }

        if attribute.className == "CIVector" {
            return (value as? CIVector)?.cgRectValue ?? .zero
        }

        return .zero
    }

    var identity: Value? {
        guard let value = attribute[kCIAttributeIdentity] else { return nil }

        if attribute.className == "NSValue" {
            #if os(macOS)
                if let rect = (value as? NSValue)?.rectValue {
                    return CGRect(x: rect.minX, y: rect.minY, width: rect.width, height: rect.height)
                }
            #endif

            #if os(iOS)
                return (value as? NSValue)?.cgRectValue

            #endif
        }

        if attribute.className == "CIVector" {
            return (value as? CIVector)?.cgRectValue
        }

        return nil
    }
}

extension ValueDescription where Value == CIColor {
    var `default`: Value {
        (attribute[kCIAttributeDefault] as? CIColor) ?? .init()
    }

    var identity: Value? {
        attribute[kCIAttributeDefault] as? CIColor
    }
}

#if os(macOS)

    extension ValueDescription where Value == NSAffineTransform {
        var `default`: Value {
            guard let value = attribute[kCIAttributeDefault] else { return NSAffineTransform(transform: .identity) }

            if attribute.className == "NSAffineTransform" {
                return (value as? NSAffineTransform) ?? NSAffineTransform(transform: .identity)
            }

            return NSAffineTransform(transform: .identity)
        }

        var identity: Value? {
            attribute[kCIAttributeDefault] as? NSAffineTransform
        }
    }

#endif

#if os(iOS)

    extension ValueDescription where Value == CGAffineTransform {
        var `default`: Value {
            guard let value = attribute[kCIAttributeDefault] else { return .identity }

            if attribute.className == "NSValue" {
                return (value as? NSValue)?.cgAffineTransformValue ?? .identity
            }

            if attribute.className == "CIVector" {
                return (value as? CIVector)?.cgAffineTransformValue ?? .identity
            }

            return .identity
        }

        var identity: Value? {
            guard let value = attribute[kCIAttributeDefault] else { return nil }

            if attribute.className == "NSValue" {
                return (value as? NSValue)?.cgAffineTransformValue
            }

            if attribute.className == "CIVector" {
                return (value as? CIVector)?.cgAffineTransformValue
            }

            return nil
        }
    }

#endif
