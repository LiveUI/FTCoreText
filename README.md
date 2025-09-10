# FTCoreText

A Swift 6 refactor of the original Objective-C component with support for Swift Package Manager.

An open source Swift interface component that uses the CoreText framework to render static text content with a highly customisable markup syntax.

<table>
  <tr>
    <td>
       <a href="https://raw.github.com/Ridiculous-Innovations/FTCoreText/documentation/screenshots/ftcoretext-screenshot-1.png">
          <img src="https://raw.github.com/Ridiculous-Innovations/FTCoreText/documentation/screenshots/ftcoretext-screenshot-1-thumb.png" alt="FTCoreText \"Giraffe\" example screenshot"/>
       </a>
    </td>
    <td>
       <a href="https://raw.github.com/Ridiculous-Innovations/FTCoreText/documentation/screenshots/ftcoretext-screenshot-2.png">
          <img src="https://raw.github.com/Ridiculous-Innovations/FTCoreText/documentation/screenshots/ftcoretext-screenshot-2-thumb.png" alt="FTCoreText \"Giraffe\" example screenshot"/>
       </a>
    </td>
    <td>
       <a href="https://raw.github.com/Ridiculous-Innovations/FTCoreText/documentation/screenshots/ftcoretext-screenshot-3.png">
          <img src="https://raw.github.com/Ridiculous-Innovations/FTCoreText/documentation/screenshots/ftcoretext-screenshot-3-thumb.png" alt="FTCoreText inlined Base64-encoded images example screenshot"/>
       </a>
    </td>
  </tr>
</table>

## Usage

### Implement FTCoreText into your project

#### Manually

1. Download `FTCoreText` sources from repository
2. Add files in `Sources/FTCoreText` folder to your project
3. Include `CoreText.framework` in your project

#### Using Swift Package Manager

1. In Xcode select "Add Packages..." and use the repository URL.
2. Add "FTCoreText" to your target dependencies.

#### CocoaPods

CocoaPods is no longer supported. Please use Swift Package Manager or Tuist.

### Demo App with Tuist

A minimal iOS application showcasing `FTCoreTextView` is included in the
repository and uses [Tuist](https://tuist.io/) for project generation.

1. Install Tuist: `curl -Ls https://install.tuist.io | bash`
2. Run `tuist generate --open` from the repository root.
3. Select the *FTCoreTextDemo* scheme and run on a simulator.
   - Demo requires iOS 14.0+ (uses modern cell configuration APIs).
   - Demo assets live under `DemoApp/Resources/Assets.xcassets`. A placeholder `DemoImage` imageset is included; add your own `demo.png` there to see the image example.
   - Add text examples under `DemoApp/Resources/Texts`. Any `*.txt` files there automatically appear in the app under the “Resource:” section.

### Use FTCoreTextView

#### 1. Import FTCoreText
```swift
import FTCoreText
```

#### 2. Create an instance of `FTCoreTextView`

#### 3. Create styles to apply to the output by creating instances of `FTCoreTextStyle`

```swift
//  Draw text enclosed in <red> tag in red color
//  Example: <red>this will be drawn red</red>
var redStyle = FTCoreTextStyle(name: "red")
redStyle.color = .red
```

#### 4. Once styles are defined, apply them to the view: 
```swift
coreTextView.addStyles([style1, style2, style3])
```

#### 4. Link tags (`<_link>`)

Links support either a raw URL or a `url|display` pair inside the tag. Tapping a link opens it with `UIApplication`:

```swift
coreTextView.addStyles(FTCoreTextDefaults.defaultStyles())
coreTextView.text = "See <_link>https://github.com/LiveUI/FTCoreText|FTCoreText</_link> on GitHub"
```

#### 5. Set text with the markup to the `FTCoreTextView` instance
```swift
coreTextView.text = "My text with <red>red</red> word."
```

See the included examples project highlighting various features.

## Supported Tags

The Swift version currently supports a focused subset of tags via the `FTCoreTextTag` names:

- `__default` (`FTCoreTextTag.default`): base font/color applied to all text.
- `__paragraph` (`FTCoreTextTag.paragraph`): paragraph styling (alignment, inset, spacing).
- `__link` (`FTCoreTextTag.link`): link styling; content supports `url|display`; links are tappable in `FTCoreTextView`.
- `__bullet` (`FTCoreTextTag.bullet`): bullet styling (character/font/color). List layout with a simple hanging indent.
- `__image` (`FTCoreTextTag.image`): inline images via either `<_image>AssetName</_image>` (asset catalog) or `<_image>base64:...</_image>` (Base64-encoded PNG/JPEG).
- `__page` (`FTCoreTextTag.page`): page-splitting utility via `FTCoreTextView.pages(from:)` (not auto-paginated).

Notes:
- Custom tags are supported by creating an `FTCoreTextStyle` with the tag name you want (e.g., `"_code"`) and using `<_code>...</_code>` in text.
- For a left-floating image effect, place `<_image>...</_image>` at the start and apply a left paragraph inset equal to the image width + padding (see the demo example). Full exclusion-path wrapping is not implemented.

## Notes

1. Demo app requires iOS 14.0+. The Swift package targets iOS 13.0+ and macOS 10.15+.
2. Although `FTCoreTextView` uses an HTML-like markup, only the tags and attributes described above are supported.

## Contact

FTCoreText is developed by LiveUI & [manGoweb](http://www.mangoweb.cz/en). Please [drop us an email](mailto:open-source@mangoweb.cz) to let us know you how you are using this component.

## License

Open Source Initiative OSI - The MIT License (MIT):Licensing [OSI Approved License] The MIT License (MIT)

Copyright (c) 2011-2018 LiveUI

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
