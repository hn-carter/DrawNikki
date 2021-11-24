//
//  BubbleView.swift
//  DrawNikki
//
//  Created by hn-carter on 2021/11/23.
//

import SwiftUI

struct BubbleView: View {
    
    struct BubbleShape: Shape {
        // 吹き出しの向き
        enum Direction {
            case top
            case bottom
            case left
            case right
        }

        // 吹き出しをつける位置
        private let direction: Direction
        //　角丸の半径
        private let radius: CGFloat
        // 吹き出しの出っ張りサイズ
        private let tailSize: CGFloat

        /**
         radius : コーナーの丸の半径
         tailSize : 吹き出しの突起サイズ
         */
        init(direction: Direction = .bottom, radius: CGFloat = 10, tailSize: CGFloat = 20) {
            self.direction = direction
            self.radius = radius
            self.tailSize = tailSize
        }

        func path(in rect: CGRect) -> Path {
            let path = getBubblePath(in: rect)
            return path
        }
        
        private func getBubblePath(in rect: CGRect) -> Path {
            let bubblePath = Path { p in
                var x: [CGFloat] = [rect.minX, rect.minX, rect.maxX, rect.maxX]
                var y: [CGFloat] = [rect.maxY, rect.minY, rect.minY, rect.maxY]
                if direction == .top {
                    y[1] += tailSize
                    y[2] += tailSize
                }
                if direction == .bottom {
                    y[0] -= tailSize
                    y[3] -= tailSize
                }
                if direction == .left {
                    x[0] += tailSize
                    x[1] += tailSize
                }
                if direction == .right {
                    x[2] -= tailSize
                    x[3] -= tailSize
                }
                
                // 左下から左上へ向かって描く
                if direction == .left {
                    p.move(to: CGPoint(x: x[0], y:y[0] - radius))
                    p.addLine(to: CGPoint(x: x[0], y: (y[0] - y[1] - tailSize) / 2))
                    p.addLine(to: CGPoint(x: rect.minX, y: (y[0] - y[1]) / 2))
                    p.addLine(to: CGPoint(x: x[0], y: (y[0] - y[1] + tailSize) / 2))
                    p.addLine(to: CGPoint(x: x[1], y: y[1] + radius))
                } else {
                    p.move(to: CGPoint(x: x[0], y: y[0] - radius))
                    p.addLine(to: CGPoint(x: x[1], y: y[1] + radius))
                }
                // 左上角
                p.addArc(
                    center: CGPoint(x: x[1] + radius, y: y[1] + radius),
                    radius: radius,
                    startAngle: Angle(degrees: 180),
                    endAngle: Angle(degrees: 270),
                    clockwise: false
                )
                // 左上から右上へ向かって描く
                if direction == .top {
                    p.addLine(to: CGPoint(x: (x[2] - x[1] - tailSize) / 2, y: y[2]))
                    p.addLine(to: CGPoint(x: (x[2] - x[1]) / 2, y: rect.minY))
                    p.addLine(to: CGPoint(x: (x[2] - x[1] + tailSize) / 2, y: y[2]))
                    p.addLine(to: CGPoint(x: x[2] - radius, y: y[2]))
                } else {
                    p.addLine(to: CGPoint(x: x[2] - radius, y: y[2]))
                }
                // 右上角
                p.addArc(
                    center: CGPoint(x: x[2] - radius, y: y[2] + radius),
                    radius: radius,
                    startAngle: Angle(degrees: 270),
                    endAngle: Angle(degrees: 0),
                    clockwise: false
                )
                // 右上から右下に向かって描く
                if direction == .right {
                    p.addLine(to: CGPoint(x: x[2], y: (y[3] - y[2] - tailSize) / 2))
                    p.addLine(to: CGPoint(x: rect.maxX, y: (y[3] - y[2]) / 2))
                    p.addLine(to: CGPoint(x: x[3], y: (y[3] - y[2] + tailSize) / 2))
                    p.addLine(to: CGPoint(x: x[3], y: y[3] - radius))
                } else {
                    p.addLine(to: CGPoint(x: x[3], y: y[3] - radius))
                }
                // 右下角
                p.addArc(
                    center: CGPoint(x: x[3] - radius, y: y[3] - radius),
                    radius: radius,
                    startAngle: Angle(degrees: 0),
                    endAngle: Angle(degrees: 90),
                    clockwise: false
                )
                // 右下から左下に向かって描く
                if direction == .bottom {
                    p.addLine(to: CGPoint(x: (x[3] - x[0] - tailSize) / 2, y: y[3]))
                    p.addLine(to: CGPoint(x: (x[3] - x[0]) / 2, y: rect.maxY))
                    p.addLine(to: CGPoint(x: (x[3] - x[0] + tailSize) / 2, y: y[3]))
                    p.addLine(to: CGPoint(x: x[0] + radius, y: y[0]))
                } else {
                    p.addLine(to: CGPoint(x: x[0] + radius, y: y[0]))
                }
                // 左下角
                p.addArc(
                    center: CGPoint(x: x[0] + radius, y: y[0] - radius),
                    radius: radius,
                    startAngle: Angle(degrees: 90),
                    endAngle: Angle(degrees: 180),
                    clockwise: false
                )
            }
            
            return bubblePath
        }
    }
    
    var direction: BubbleShape.Direction = BubbleShape.Direction.left
    var backGround: Color = Color(red: 255/255, green: 240/255, blue: 230/255)

    var body: some View {
        BubbleShape(direction: direction)
            .fill(backGround)
            //.fill(Color(red: 255/255, green: 250/255, blue: 240/255))
            //.stroke(Color.red)
            

    }
}

struct BubbleView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            BubbleView(direction: BubbleView.BubbleShape.Direction.left)
                .frame(width: 300, height: 200)
            BubbleView(direction: BubbleView.BubbleShape.Direction.top)
                .frame(width: 300, height: 200)
            BubbleView(direction: BubbleView.BubbleShape.Direction.right)
                .frame(width: 300, height: 200)
            BubbleView(direction: BubbleView.BubbleShape.Direction.bottom)
                .frame(width: 300, height: 200)
        }
    }
}
