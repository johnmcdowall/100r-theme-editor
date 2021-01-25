module Section.Mixer exposing (view)

import Color
import Color.Convert exposing (colorToHex)
import Helper.Color exposing (convColor, getColorValue, getSelectedColor)
import Helper.Styles
import Css exposing (..)
import Html.Styled as Html exposing (Html, Attribute, button, div, input, label)
import Html.Styled.Attributes as Attr exposing (class, css, type_, value, step)
import Html.Styled.Events exposing (onClick, onInput, onFocus, onBlur)
import Model exposing (Model, SelectedColor(..), ColorMode(..), ValueEditType(..))
import Rpx exposing (blc, rpx)



type alias ColorEditMsg msg = ValueEditType -> String -> msg
type alias ColorModeMsg msg = ColorMode -> msg
type alias HexEdit msg = String -> msg
type alias HexFocus msg = Bool -> msg

view : Model ->  ColorModeMsg msg -> ColorEditMsg msg -> HexEdit msg -> HexFocus msg -> Html msg
view model colorModeMsg colorEditMsg hexEditMsg hexFocusMsg =
    div
        [ class "section-mixer"
        , css   
            [ displayFlex
            , marginBottom (blc 4)
            ]
        ]
        [ colorArea model hexEditMsg hexFocusMsg

        , div [ css [width (blc 1)]][]

        , div
            [ class "slider-area"
            , css
                [ width (blc <| (18*3) + (2*3))
                ]
            ]
            [ div
                [ class "color-values"
                , css
                    [ displayFlex
                    , flexDirection column
                    ]
                ]
                [ div
                    [ class "colorMode"
                    ]
                    [ colorModeButton model colorModeMsg HSL "HSL"
                    , colorModeButton model colorModeMsg RGB "RGB"
                    ]
                , div
                    [ class "sliderArea"
                    ]
                    [ case model.colorEditMode of
                        HSL -> hslSliders model colorEditMsg
                        RGB -> rgbSliders model colorEditMsg
                    ]
                ]
            ]
        ]


colorArea : Model -> HexEdit msg -> HexFocus msg -> Html msg
colorArea model hexEditMsg hexFocusMsg =
    let
        theme = model.theme
        label = 
            case model.selectedColor of
                Background -> "background"
                FHigh -> "f_high"
                FMed -> "f_med"
                FLow -> "f_low"
                FInv -> "f_inv"
                BHigh -> "b_high"
                BMed -> "b_med"
                BLow -> "b_low"
                BInv -> "b_inv"
        
        colorPrev = getSelectedColor model

        maybeHexVal : List (Attribute msg)
        maybeHexVal =
            case model.hexInputFocused of
                False -> [ value <| model.hexInputValue ]
                True -> [ value <| model.hexInputValue ]
    in
        div
            [ class "preview"
            , css
                [ displayFlex
                , flexDirection column
                , width (Rpx.add Helper.Styles.cellWidth (blc 2))
                ]
            ]
            [ div
                [ css
                    [ height (blc 4)
                    , padding (blc 1)
                    ]
                ]
                [ Html.text label ]

                
            , input
                (   [ class "hex"
                    , type_ "text"
                    , Attr.maxlength 7
                    , onInput hexEditMsg

                    , onBlur <| hexFocusMsg False
                    , onFocus <| hexFocusMsg True

                    , css
                        [ --- housecleaning
                        border zero

                        --- real styles
                        , textBoxStyle
                        , Helper.Styles.defaultFonts
                        , backgroundColor (convColor theme.bHigh)
                        , color (convColor theme.fHigh)
                        ]
                    ]
                    ++ maybeHexVal
                )
                []


            , div
                [ class "preview"
                , css
                    [ boxSizing borderBox
                    , height (blc 11)

                    , backgroundColor (convColor colorPrev)

                    , Css.batch (
                        case model.selectedColor of
                            Background -> [ border3 (rpx 1) solid (convColor theme.bMed)]
                            _ -> []
                        )
                    ]
                ]
                []
            ]

colorModeButton : Model -> ColorModeMsg msg -> ColorMode -> String -> Html msg
colorModeButton model msg colorMode label =
    button
        [ css
            [ Helper.Styles.buttonStyles

            , minWidth <| Rpx.add Helper.Styles.cellWidth (blc 2)
            , height (blc 5)
            , padding (blc 1)

            , border zero
            , fontWeight (int 600)
            , Helper.Styles.defaultFonts

            , Css.batch (
                case model.colorEditMode == colorMode of
                    True ->
                        [ backgroundColor (convColor model.theme.bLow)
                        , color (convColor model.theme.fMed)
                        ]
                    False ->
                        [ backgroundColor unset
                        , color (convColor model.theme.fLow)
                        ]
                )

            , textAlign left

            , boxSizing borderBox
            ]
            
        , onClick <| msg colorMode
        ]
        [ Html.text label ]


rgbSliders : Model -> ColorEditMsg msg -> Html msg
rgbSliders model colorEditMsg =
    div
        [ css [ marginTop (blc 2) ]
        ]
        [ slider model colorEditMsg "R" Red 0 255
        , slider model colorEditMsg "G" Green 0 255
        , slider model colorEditMsg "B" Blue 0 255
        ]


hslSliders : Model -> ColorEditMsg msg -> Html msg
hslSliders model colorEditMsg =
    div
        [ css [ marginTop (blc 2) ]
        ]
        [ slider model colorEditMsg "H" Hue 0 360 
        , slider model colorEditMsg "S" Saturation 0 100
        , slider model colorEditMsg "L" Lightness 0 100
        ]

    
slider : Model -> ColorEditMsg msg -> String -> ValueEditType -> Int -> Int -> Html msg
slider model colorEditMsg labelStr editType minVal maxVal =
    div
        [ class "sliderArea"
        , css
            [ displayFlex
            , flexDirection row
            , alignItems center
            , height (blc 4)
            , marginTop (blc 1)
            ]

        ]
        [ label
            []
            []

        ----------- LABEL
        , div
            [ css
                [ textBoxStyle
                , width (blc 2)
                , color (convColor model.theme.fMed)
                ]

            ]
            [Html.text labelStr]
        
        ----------- THE ACTUAL SLIDER
        , input
            [ type_ "range"
            , Attr.min <| String.fromInt minVal
            , Attr.max <| String.fromInt maxVal
            , onInput (colorEditMsg editType)
            , value <| getColorValue model editType

            , css
                [ -- housecleaning styles
                  width (pct 100) -- apparently FF needs this
                , property "-webkit-appearance" "none"
                , property "background" "transparent"

                , pseudoClass "-webkit-slider-thumb"
                    [ property "-webkit-appearance" "none"
                    ]
                , pseudoClass "-ms-track"
                    [ width (pct 100)
                    , cursor pointer
                    , property "background" "transparent"
                    , property "border-color" "transparent"
                    , property "color" "transparent"
                    ]
                , pseudoClass "focus"
                    [property "outline" "none"]


                , sliderThumb
                    [ width (blc 2)
                    , height (blc 2)
                    , marginTop (blc -1) -- specifying a margin is mandatory in Chrome
                    
                    , cursor pointer

                    , borderRadius (blc 1)
                    , backgroundColor (convColor model.theme.fMed)
                    ]

                , sliderTrack
                    [ height (rpx 2)
                    , color (convColor model.theme.fLow)
                    , backgroundColor (convColor model.theme.fLow)
                    ]
                ]
            ]
            []

        ----------- TEXT BOX
        , input
            [ class "text"
            , type_ "number"
            , onInput (colorEditMsg editType)
            , value <| getColorValue model editType
            , Attr.min <| String.fromInt minVal
            , Attr.max <| String.fromInt maxVal
            , step "1"

            , css
                [ ---- housecleaning

                  pseudoClass "-webkit-outer-spin-button"
                    [ property "-webkit-appearance" "none"
                    , margin zero
                    ]

                , pseudoClass "-webkit-inner-spin-button"
                    [ property "-webkit-appearance" "none"
                    , margin zero
                    ]

                , property "-moz-appearance" "textfield"
                , border zero

                ---- normal styles    
                , textBoxStyle
                , Helper.Styles.defaultFonts
                , color (convColor model.theme.fHigh)
                , width (blc 5)
                , marginLeft (blc 2)
                , backgroundColor (convColor model.theme.bHigh)
                ]
            ]
            [Html.text <| getColorValue model editType]
        ]
        

textBoxStyle : Style
textBoxStyle =
    Css.batch
        [ displayFlex
        , alignItems center
        , padding2 zero (blc 1)
        , height (blc 4)
        ]


sliderThumb : List Style -> Style
sliderThumb styles =
    Css.batch
        [ pseudoClass "-webkit-slider-thumb" styles
        , pseudoClass "-moz-range-thumb" styles
        ]

sliderTrack : List Style -> Style
sliderTrack styles =
    Css.batch
        [ pseudoClass "-webkit-slider-runnable-track" styles
        , pseudoClass "-moz-range-track" styles
        ]
