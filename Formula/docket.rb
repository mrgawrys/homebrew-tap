# Source of truth for mrgawrys/homebrew-tap. The tap's copy is generated from
# this file on every tag push by .github/workflows/release.yml, which fills in
# the version and both sha256s — so edits made in the tap are lost next release.
class Docket < Formula
  desc "Pre-runs Claude Code's /code-review on PRs awaiting your review"
  homepage "https://github.com/mrgawrys/docket"
  version "0.3.5"

  on_arm do
    url "https://github.com/mrgawrys/docket/releases/download/v#{version}/docket-darwin-arm64.tar.gz"
    sha256 "79d1fe86a42ad779790149b2b1679de19cf22b7d0feab01b66b8fd53dcfad4f4"
  end

  on_intel do
    url "https://github.com/mrgawrys/docket/releases/download/v#{version}/docket-darwin-x64.tar.gz"
    sha256 "1d5bae3f8a49ea94f222777adbf750289e4078db4318762c542d5a7b5c668e3e"
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
