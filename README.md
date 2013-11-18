#FTCoreText

An open source Objective-C interface component that makes use of the CoreText framework to render static text content using a highly customisable markup syntax.

<table>
  <tr>
    <td>
       <a href="https://raw.github.com/FuerteInternational/FTCoreText/documentation/screenshots/ftcoretext-screenshot-1.png">
          <img src="https://raw.github.com/FuerteInternational/FTCoreText/documentation/screenshots/ftcoretext-screenshot-1-thumb.png" alt="FTCoreText \"Giraffe\" example screenshot"/>
       </a>
    </td>
    <td>
       <a href="https://raw.github.com/FuerteInternational/FTCoreText/documentation/screenshots/ftcoretext-screenshot-2.png">
          <img src="https://raw.github.com/FuerteInternational/FTCoreText/documentation/screenshots/ftcoretext-screenshot-2-thumb.png" alt="FTCoreText \"Giraffe\" example screenshot"/>
       </a>
    </td>
    <td>
       <a href="https://raw.github.com/FuerteInternational/FTCoreText/documentation/screenshots/ftcoretext-screenshot-3.png">
          <img src="https://raw.github.com/FuerteInternational/FTCoreText/documentation/screenshots/ftcoretext-screenshot-3-thumb.png" alt="FTCoreText inlined Base64-encoded images example screenshot"/>
       </a>
    </td>
  </tr>
</table>

##Usage

### Implement FTCoreText into your project

#### Manually

1. Download `FTCoreText` sources from repository
2. Add files in `FTCoreText` folder to your project
3. Include `CoreText.framework` in your project

#### Using CocoaPods

1. Use `FTCoreText` pod

### Use FTCoreTextView

#### 1. Import FTCoreText
```objective-c
#import FTCoreTextView.h
```

#### 2. Create an instance of `FTCoreTextView`

#### 3. Create styles to apply to the output by creating instances of `FTCoreTextStyle`

```objective-c
//  Draw text closed in <red> tag in red color
//  Example: <red>this will be drawn red</red>
FTCoreTextStyle *redStyle = FTCoreTextStyle *imageStyle = [FTCoreTextStyle styleWithName:@"red"];
redStyle.color = [UIColor redColor];
```

#### 4. Once styles are defined, apply them to the view: 
```objective-c
[ftCoreTextInstance addStyles:@[style1, style2, style3]];
```

#### 5. Set text with corrent markdown to the `FTCoreTextView` instance
```objective-c
ftCoreTextInstance.text = @"My text with <red>red</red> word.";
```

See the included examples project highlighting various features.

##Elements

FTCoreText provides some interface element types for rendering content types commonly found on the web and printed media such as lists, images, links and suchlike.

Included:

- `FTCoreTextTagDefault`: the default style applied to the text. 
- `FTCoreTextTagPage`: Divide the text in pages. Markup: `<_page/>`
- `FTCoreTextTagBullet`: define styles for bullets. Markup: `<_bullet>content</bullet>`.
- `FTCoreTextTagImage`: renders images. Markup: `<_image>imageNameOnBundle.extension</_image>`
- `FTCoreTextTagLink`: define style for links. Markup: `<_link>link_target|link - name</_link>`. See `FTCoreTextViewDelegate` for responding to touch.

To use the included element types, set the name of an `FTCoreTextStyle` style instance to one of the string constant types above and use the markup specified. Example: `linkTypeFTCoreTextStyleInstance.name = FTCoreTextTagLink`, and in the static content: `<_link>http://fuerteint.com|Fuerte International</_link>`

##Notes

1. Use of the CoreText framework is available for iOS versions 3.2 and above.

2. Although FTCoreTextView uses a similar markup syntax to HTML, most of the properties defined in the HTML specification are unsupported.

##Contact

FTCoreText is developed by [FuerteInt](http://fuerteint.com). Please [drop us an email](mailto:open-source@fuerteint.com) to let us know you how you are using this component.

##License

Open Source Initiative OSI - The MIT License (MIT):Licensing [OSI Approved License] The MIT License (MIT)

Copyright (c) 2013 Fuerte International

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.