//
//  SpinModel.swift
//  YKSpinWheel
//
//  Created by Yakup Kavak on 1.04.2026.
//

import SwiftUI

/// A data model representing a single slice on the spin wheel.
///
/// `SpinModel` holds the unique identifier, a highly flexible background view, and enforces
/// valid combinations of images and text (either localized or dynamic strings) at compile time.
/// By leveraging `AnyView`, it allows a single array to contain slices with completely different
/// background types (e.g., `Color`, `LinearGradient`, or `Image`).
///
/// - Note: Initializers enforce that a model must contain at least a text, an image, or both.
/// It cannot be initialized with both being empty or `nil`.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct SpinModel: Identifiable {
    
    // MARK: - Properties
    
    /// The unique identifier for the slice. Required for SwiftUI loops (ForEach).
    public let id: Int
    
    /// An optional string representing the system image (SF Symbol) to display.
    public let sfImageName: String?
    
    /// An optional SwiftUI image to display.
    public let image: Image?
    
    /// An optional custom view (e.g., KFImage) to display as an icon.
    public let customImage: AnyView?
    
    /// An optional localized string key for the text.
    public let textKey: LocalizedStringKey?
    
    /// An optional dynamic string for the text.
    public let textString: String?
    
    /// The background of the slice, stored as a type-erased `AnyView`.
    public let background: AnyView
    
    /// The relative proportion (weight) of the slice compared to others.
    /// Default is 1.0. If one slice has a weight of 2.0 and another 1.0, the first will be twice as large.
    public let weight: Double
    
    // MARK: - Initialization (Both Text and Image/Icon)
    
    /// Initializes a spin model with a localized text and an sf image.
    public init<V>(
        id: Int,
        textKey: LocalizedStringKey,
        sfImageName: String,
        weight: Double = 1.0,
        background: V
    ) where V: View {
        self.id = id
        self.textKey = textKey
        self.textString = nil
        self.image = nil
        self.customImage = nil
        self.sfImageName = sfImageName
        self.weight = weight
        self.background = AnyView(background)
    }
    
    /// Initializes a spin model with a dynamic string text and an sf image.
    public init<V, S>(
        id: Int,
        text: S,
        sfImageName: String,
        weight: Double = 1.0,
        background: V
    ) where V: View, S: StringProtocol {
        self.id = id
        self.textKey = nil
        self.textString = String(text)
        self.image = nil
        self.customImage = nil
        self.sfImageName = sfImageName
        self.weight = weight
        self.background = AnyView(background)
    }
    
    /// Initializes a spin model with a localized text and an asset image.
    public init<V>(
        id: Int,
        textKey: LocalizedStringKey,
        image: Image,
        weight: Double = 1.0,
        background: V
    ) where V: View {
        self.id = id
        self.textKey = textKey
        self.textString = nil
        self.image = image
        self.customImage = nil
        self.sfImageName = nil
        self.weight = weight
        self.background = AnyView(background)
    }
    
    /// Initializes a spin model with a dynamic string text and an asset image.
    public init<V, S>(
        id: Int,
        text: S,
        image: Image,
        weight: Double = 1.0,
        background: V
    ) where V: View, S: StringProtocol {
        self.id = id
        self.textKey = nil
        self.textString = String(text)
        self.image = image
        self.customImage = nil
        self.sfImageName = nil
        self.weight = weight
        self.background = AnyView(background)
    }
    
    /// Initializes a spin model with a localized text and a custom image/view.
    public init<V, C>(
        id: Int,
        textKey: LocalizedStringKey,
        customImage: C,
        weight: Double = 1.0,
        background: V
    ) where V: View, C: View {
        self.id = id
        self.textKey = textKey
        self.textString = nil
        self.image = nil
        self.sfImageName = nil
        self.customImage = AnyView(customImage)
        self.weight = weight
        self.background = AnyView(background)
    }
    
    /// Initializes a spin model with a dynamic string text and a custom image/view.
    public init<V, S, C>(
        id: Int,
        text: S,
        customImage: C,
        weight: Double = 1.0,
        background: V
    ) where V: View, S: StringProtocol, C: View {
        self.id = id
        self.textKey = nil
        self.textString = String(text)
        self.image = nil
        self.sfImageName = nil
        self.customImage = AnyView(customImage)
        self.weight = weight
        self.background = AnyView(background)
    }
    
    // MARK: - Initialization (Text Only)
    
    /// Initializes a spin model with only a localized text.
    public init<V>(
        id: Int,
        textKey: LocalizedStringKey,
        weight: Double = 1.0,
        background: V
    ) where V: View {
        self.id = id
        self.textKey = textKey
        self.textString = nil
        self.image = nil
        self.sfImageName = nil
        self.customImage = nil
        self.weight = weight
        self.background = AnyView(background)
    }
    
    /// Initializes a spin model with only a dynamic string text.
    public init<V, S>(
        id: Int,
        text: S,
        weight: Double = 1.0,
        background: V
    ) where V: View, S: StringProtocol {
        self.id = id
        self.textKey = nil
        self.textString = String(text)
        self.sfImageName = nil
        self.image = nil
        self.customImage = nil
        self.weight = weight
        self.background = AnyView(background)
    }
    
    // MARK: - Initialization (Image/Icon Only)
    
    /// Initializes a spin model with only an sf image.
    public init<V>(
        id: Int,
        sfImageName: String,
        weight: Double = 1.0,
        background: V
    ) where V: View {
        self.id = id
        self.textKey = nil
        self.textString = nil
        self.image = nil
        self.customImage = nil
        self.sfImageName = sfImageName
        self.weight = weight
        self.background = AnyView(background)
    }
    
    /// Initializes a spin model with only an asset image.
    public init<V>(
        id: Int,
        image: Image,
        weight: Double = 1.0,
        background: V
    ) where V: View {
        self.id = id
        self.textKey = nil
        self.textString = nil
        self.image = image
        self.customImage = nil
        self.sfImageName = nil
        self.weight = weight
        self.background = AnyView(background)
    }
    
    /// Initializes a spin model with only a custom image/view.
    public init<V, C>(
        id: Int,
        customImage: C,
        weight: Double = 1.0,
        background: V
    ) where V: View, C: View {
        self.id = id
        self.textKey = nil
        self.textString = nil
        self.image = nil
        self.sfImageName = nil
        self.customImage = AnyView(customImage)
        self.weight = weight
        self.background = AnyView(background)
    }
}

// MARK: - Hashable & Equatable Conformance

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension SpinModel: Hashable, Equatable {
    
    public static func == (lhs: SpinModel, rhs: SpinModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
