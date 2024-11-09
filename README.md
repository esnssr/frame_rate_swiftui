# SwiftUI Frame Rate Shenanigans


i have noticed that the behavior for running animations on SwiftUI is different than UIKit. i was working on a simple sheet-like presentation animation in SwiftUI when i noticed the animation is not smooth when running on physical device? i suspected that maybe i am doing something wrong.

looked it up online, and found this [post](https://x.com/ChristianSelig/status/1504496680774819851) (which i have seen two years ago) talking about the same issue. i didn't have the `CADisableMinimumFrameDurationOnPhone` key, so i added that, but still my issue was still not fixed. SwiftUI was still dropping frames on the physical device.

i quickly made a small demo project, and added the exact same animation for both UIKit and SwiftUI for 1 second, even though in my original animation i was using 300ms. i immediately noticed the difference when running both animations (UIKit and SwiftUI) side by side. instruments shows that SwiftUI drops to 16ms (60Hz) on my iPhone 14 Pro (which supports 120Hz Pro Motion) while UIKit doesn't and moves with 8ms.
> if you are not familiar with timings and refresh rates for Pro Motion displays take a look [here](https://developer.apple.com/documentation/quartzcore/optimizing_promotion_refresh_rates_for_iphone_13_pro_and_ipad_pro).

<img src = 'https://github.com/user-attachments/assets/f815a4a4-7afd-47b8-95a5-f8d7436b5b1b' height = 500> 
<img src = 'https://github.com/user-attachments/assets/d40cbcc8-e76c-4c01-bba3-7446ffbc6d17' height = 500>


anyways, i am now desperate 😅. i am trying to avoid using UIKit here (or maybe i will? 👀), so i would appreciate any help here!

you can see the difference by downloading and running the project in this repo, or copy paste the contents of this [file](https://github.com/esnssr/frame_rate_swiftui/blob/main/frame_rate_swiftui/frame_rate_ahhhhh.swift) to your own created project. you have to run it on a physical device to see the issue.
then:

- toggle SwiftUI view animation, notice how the view animation glitches a little bit. the behavior can sometimes be inconstant, but if you run the animation multiple times you will %100 see it dropping to 60Hz.
- try to run toggle the UIKit view animation. this will always run smoothly on 120Hz.
- try to toggle both. sometimes SwiftUI will drop to 60Hz and sometimes it doesn't. but toggling the SwiftUI view you will almost always see it dropping to 60Hz.

# peviews 📺
i don't think the videos here make the difference clear, but here are some previews of the issue.
## SwiftUI

https://github.com/user-attachments/assets/0b95e367-b528-4b75-9e6c-6723183440c7


## UIKit

https://github.com/user-attachments/assets/06b2759c-fb57-457d-b10e-734a4d6e0319



