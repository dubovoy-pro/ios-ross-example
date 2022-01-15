//
//  PlotView.swift
//  bcoin
//
//  Created by Yury Dubovoy on 13.01.2022.
//

import UIKit
import SnapKit

final class PlotView: UIView {
    
    private let drawingView = UIImageView()
    
    private var histPrices: [CoincapAPI.HistPrice] = []

    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {

        addSubview(drawingView)

        drawingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func updateUI(histPrices: [CoincapAPI.HistPrice]) {
        self.histPrices = histPrices
        layoutSubviews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        drawPlot(histPrices: histPrices)
    }
    

    
    private func drawPlot(histPrices: [CoincapAPI.HistPrice]) {
        
        let viewWidth = Double(drawingView.frame.width);
        let viewHeight = Double(drawingView.frame.height);
        let topOffset = 20.0
        let bottomOffset = 20.0
        let labelH = 20.0
        let labelOffset = 4.0
        let viewPortH = viewHeight - topOffset - bottomOffset - labelOffset * 2
        let viewPortW = viewWidth

        var img: UIImage? = nil
        
        defer {
            drawingView.image = img
        }

        guard let maxPrice = (histPrices.max { $0.priceUsdDouble < $1.priceUsdDouble }) else {
           return
        }

        guard let minPrice = (histPrices.min { $0.priceUsdDouble < $1.priceUsdDouble }) else {
           return
        }

        guard let startPrice = histPrices.first else {
           return
        }

        guard let endPrice = histPrices.last else {
           return
        }

        let maxDiff = maxPrice.priceUsdDouble - minPrice.priceUsdDouble
        
        let maxTimeDiff = endPrice.time - startPrice.time
        
        
        let renderer = UIGraphicsImageRenderer(
            size:CGSize(width: CGFloat(viewWidth), height: CGFloat(viewHeight)))

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center

        var attributes = [NSAttributedString.Key: AnyObject]()
        let textFont = Typography.font_400_13
        attributes[.font] = textFont
        attributes[.foregroundColor] = UIColor.textGray2
        
        
        func drawLabel(price: CoincapAPI.HistPrice, firstXpos: Double, isMax: Bool) {
            let string = price.formattedPrice
            let textW = string.width(withConstrainedHeight: labelH, font: textFont)
            var xPos = firstXpos - textW / 2
            if xPos < 0 { xPos = 0 }
            if xPos > viewPortW - textW - labelOffset { xPos = viewPortW - textW - labelOffset }
            let yPos = isMax ? 0 : viewHeight - bottomOffset + labelOffset
            string.draw(
                with: CGRect(x: xPos, y: yPos, width: viewPortW, height: labelH),
                options: .usesLineFragmentOrigin,
                attributes: attributes,
                context: nil)
        }

        
        img = renderer.image { ctx in

            ctx.cgContext.setLineWidth(1)

            for i in 0...histPrices.count - 2 {

                ctx.cgContext.setStrokeColor(UIColor.baseBlack.cgColor)

                let first = histPrices[i]
                let second = histPrices[i + 1]

                let firstDiff = maxPrice.priceUsdDouble - first.priceUsdDouble
                let firstYpos = firstDiff * viewPortH / maxDiff

                let secondDiff = maxPrice.priceUsdDouble - second.priceUsdDouble
                let secondYpos = secondDiff * viewPortH / maxDiff
                
                let firstTimeDiff = first.time - startPrice.time
                let firstXpos = firstTimeDiff * viewPortW / maxTimeDiff

                let secondTimeDiff = second.time - startPrice.time
                let secondXpos = secondTimeDiff * viewPortW / maxTimeDiff

                ctx.cgContext.move(to: CGPoint(x: firstXpos, y: topOffset + labelOffset + firstYpos))
                ctx.cgContext.addLine(to:CGPoint(x: secondXpos, y: topOffset + labelOffset + secondYpos))
                ctx.cgContext.drawPath(using: .fillStroke)
                
                if first == maxPrice {
                    drawLabel(price: first, firstXpos: firstXpos, isMax: true)
                }
                
                if first == minPrice {
                    drawLabel(price: first, firstXpos: firstXpos, isMax: false)
                }
            }


        }

    }


    
}
