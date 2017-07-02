//
//  EmojiPalette.swift
//  DreamBig
//
//  Created by Andy Cho on 2017-06-22.
//  Copyright © 2017 AcroMace. All rights reserved.
//

import Foundation

class EmojiPalette {
    private static let paletteKey = "palette"
    private static let defaultPalette = ["💩", "👽", "🙉"]

    private var currentEmojiIndex = 0

    // Get the current emoji or the emoji at the index in the palette
    func getEmoji(index: Int? = nil) -> String {
        let palette = getPalette()
        let `index` = index ?? currentEmojiIndex
        guard index < palette.count else {
            if index == 0 {
                // If we have nothing in the palette, reset back to the default palette
                updatePalette(emojis: EmojiPalette.defaultPalette)
                print("Reset to the default palette since there were no emojis in the palette")
                return EmojiPalette.defaultPalette[0]
            } else {
                // If we indexed out of the available emojis, just reset back to the first
                currentEmojiIndex = 0
                print("Reset to the first emoji since the index was out of bounds")
                return palette[currentEmojiIndex]
            }
        }
        return palette[index]
    }

    // Select the index for the emoji currently being used
    func selectEmoji(index: Int) {
        let palette = getPalette()
        guard 0 ..< palette.count ~= index else {
            print("ERROR: Could not select emoji at index \(index) of \(palette.count) emojis")
            return
        }
        currentEmojiIndex = index
        print("Selected emoji: \(palette[index])")
    }

    // Check if the index given is the selected emoji
    func isSelectedEmoji(index: Int) -> Bool {
        return currentEmojiIndex == index
    }

    // Delete the emoji at the index
    func deleteEmoji(index: Int) {
        var palette = getPalette()
        guard 0 ..< palette.count ~= index else {
            print("ERROR: Could not delete emoji at index \(index) of \(palette.count) emojis")
            return
        }
        let deletedEmoji = palette.remove(at: index)
        print("Deleted emoji: \(deletedEmoji)")
        if index == currentEmojiIndex {
            print("Resetting emoji index since the selected emoji was deleted")
            currentEmojiIndex = 0
        }
        updatePalette(emojis: palette)
    }

    // Count the number of emojis in the palette
    func count() -> Int {
        return getPalette().count
    }

    // Add an emoji to the palette
    func addEmojiToPalette(emoji: String) {
        var palette = getPalette()
        palette.append(emoji)
        updatePalette(emojis: palette)
    }

    // MARK: - Private methods

    // Get the stored emoji palette
    private func getPalette() -> [String] {
        if let storedPalette = UserDefaults.standard.stringArray(forKey: EmojiPalette.paletteKey) {
            return storedPalette
        }

        updatePalette(emojis: EmojiPalette.defaultPalette)
        return EmojiPalette.defaultPalette
    }

    // Completely replace the emoji palette
    private func updatePalette(emojis: [String]) {
        UserDefaults.standard.set(emojis, forKey: EmojiPalette.paletteKey)
        print("Updated palette: \(emojis)")
    }

}
