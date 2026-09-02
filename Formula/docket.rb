# Source of truth for mrgawrys/homebrew-tap. The tap's copy is generated from
# this file on every tag push by .github/workflows/release.yml, which fills in
# the version and both sha256s — so edits made in the tap are lost next release.
class Docket < Formula
  desc "Pre-runs Claude Code's /code-review on PRs awaiting your review"
  homepage "https://github.com/mrgawrys/docket"
  version "0.3.6"

  on_arm do
    url "https://github.com/mrgawrys/docket/releases/download/v#{version}/docket-darwin-arm64.tar.gz"
    sha256 "ba8e2a7f5ad85b4e65a64322f5002ed74d55d64baf62933f312dcd77254972c7"
  end

  on_intel do
    url "https://github.com/mrgawrys/docket/releases/download/v#{version}/docket-darwin-x64.tar.gz"
    sha256 "a482e3e4c5c5a7a493bb057c95b99aca9dd3a73cc65d8be4e9cc0b5e33e97088"
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
