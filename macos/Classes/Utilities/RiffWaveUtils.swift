import Foundation

/// `RiffWaveUtils` is a utility struct that provides methods for handling RIFF WAVE audio files.
struct RiffWaveUtils {
    
    /// Decodes a RIFF WAVE audio file into an array of floating point numbers.
    ///
    /// This function reads the audio file data, skips the 44-byte header, and then converts each 16-bit sample into a floating point number between -1.0 and 1.0.
    ///
    /// - Parameter url: The URL of the audio file to decode.
    /// - Throws: An error if the audio file data could not be read.
    /// - Returns: An array of floating point numbers representing the audio data.
    static func decodeWaveFile(_ url: URL) throws -> [Float] {
        let data = try Data(contentsOf: url)
        let floats = stride(from: 44, to: data.count, by: 2).map {
            return data[$0..<$0 + 2].withUnsafeBytes {
                let short = Int16(littleEndian: $0.load(as: Int16.self))
                return max(-1.0, min(Float(short) / 32767.0, 1.0))
            }
        }
        return floats
    }
}