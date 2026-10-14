# Source of truth for mrgawrys/homebrew-tap. The tap's copy is generated from
# this file on every tag push by .github/workflows/release.yml, which fills in
# the version and both sha256s — so edits made in the tap are lost next release.
class Docket < Formula
  desc "Pre-runs Claude Code's /code-review on PRs awaiting your review"
  homepage "https://github.com/mrgawrys/docket"
  version "0.5.0"

  on_arm do
    url "https://github.com/mrgawrys/docket/releases/download/v#{version}/docket-darwin-arm64.tar.gz"
    sha256 "22f1b1594b79a088050e145dc68aaa46bd4667309d1e114a150fda11b4caf1ae"
  end

  on_intel do
    url "https://github.com/mrgawrys/docket/releases/download/v#{version}/docket-darwin-x64.tar.gz"
    sha256 "c1b3c6436333d112590792460edb6efb43cca0308719ca068c21dd3f7f394d56"
  end

  depends_on :macos
  depends_on "gh"
  # The `claude` CLI and the code-review plugin are runtime deps too, but neither
  # is in Homebrew — `docket doctor` is what checks the full chain.

  def install
    bin.install "docket"
    fish_completion.install "completions/docket.fish" => "docket.fish"
    zsh_completion.install "completions/_docket" => "_docket"
    bash_completion.install "completions/docket.bash" => "docket"
  end

  def caveats
    <<~EOS
      Run `docket doctor` first — it writes a starter config to
      ~/.config/docket/config.json and checks the rest of the review chain.
    EOS
  end

  test do
    assert_match "docket poll", shell_output("#{bin}/docket help")
    assert_match "unknown subcommand", shell_output("#{bin}/docket nope 2>&1", 1)
  end
end
