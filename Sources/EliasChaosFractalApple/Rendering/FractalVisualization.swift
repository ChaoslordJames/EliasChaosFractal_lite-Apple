import SwiftUI

class FractalVisualization {
    func render3D(_ field: [[Double]]) -> (NSImage, NSImage, NSImage) {
        let size = field.count > 400_000 ? 200 : 400
        UIGraphicsBeginImageContext(CGSize(width: size, height: size))
        guard let context = UIGraphicsGetCurrentContext() else { return (NSImage(), NSImage(), NSImage()) }

        for x in 0..<field.count {
            for y in 0..<field[x].count {
                let value = field[x][y]
                let color = NSColor(hue: CGFloat(value), saturation: 1.0, brightness: 1.0, alpha: 1.0)
                context.setFillColor(color.cgColor)
                context.fill(CGRect(x: x, y: y, width: 1, height: 1))
            }
        }
        let xy = NSImage(cgImage: context.makeImage()!, size: NSSize(width: size, height: size))

        UIGraphicsBeginImageContext(CGSize(width: size, height: size))
        guard let xzContext = UIGraphicsGetCurrentContext() else { return (xy, NSImage(), NSImage()) }
        for x in 0..<field.count {
            for z in 0..<field[x].count {
                let value = field[x][z]
                let color = NSColor(hue: CGFloat(value), saturation: 1.0, brightness: 1.0, alpha: 1.0)
                xzContext.setFillColor(color.cgColor)
                xzContext.fill(CGRect(x: x, y: z, width: 1, height: 1))
            }
        }
        let xz = NSImage(cgImage: xzContext.makeImage()!, size: NSSize(width: size, height: size))

        UIGraphicsBeginImageContext(CGSize(width: size, height: size))
        guard let yzContext = UIGraphicsGetCurrentContext() else { return (xy, xz, NSImage()) }
        for y in 0..<field.count {
            for z in 0..<field[y].count {
                let value = field[y][z]
                let color = NSColor(hue: CGFloat(value), saturation: 1.0, brightness: 1.0, alpha: 1.0)
                yzContext.setFillColor(color.cgColor)
                yzContext.fill(CGRect(x: y, y: z, width: 1, height: 1))
            }
        }
        let yz = NSImage(cgImage: yzContext.makeImage()!, size: NSSize(width: size, height: size))

        UIGraphicsEndImageContext()
        return (xy, xz, yz)
    }
}
