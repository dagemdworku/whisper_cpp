import Foundation

struct WhisperModelConfig {
    var nVocab: Int32
    var nAudioCtx: Int32
    var nAudioState: Int32
    var nAudioHead: Int32
    var nAudioLayer: Int32
    var nTextCtx: Int32
    var nTextState: Int32
    var nTextHead: Int32
    var nTextLayer: Int32
    var nMels: Int32
    var ftype: Int32
    var qntvr: Int32
    var type: Int32
    var extraTokens: Int32
    var modelCtx: Float
    var modelSize: Float

    init(model_config: whisper_model_config) {
        self.nVocab = model_config.n_vocab
        self.nAudioCtx = model_config.n_audio_ctx
        self.nAudioState = model_config.n_audio_state
        self.nAudioHead = model_config.n_audio_head
        self.nAudioLayer = model_config.n_audio_layer
        self.nTextCtx = model_config.n_text_ctx
        self.nTextState = model_config.n_text_state
        self.nTextHead = model_config.n_text_head
        self.nTextLayer = model_config.n_text_layer
        self.nMels = model_config.n_mels
        self.ftype = model_config.ftype
        self.qntvr = model_config.qntvr
        self.type = model_config.type
        self.extraTokens = model_config.extra_tokens
        self.modelCtx = model_config.model_ctx
        self.modelSize = model_config.model_size
    }
}
