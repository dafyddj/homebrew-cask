cask "intellij-idea-ce" do
  version "2021.1"

  if Hardware::CPU.intel?
    sha256 "d9aac4a74ad94dce22a1fb61e8db340dc4cc35d08ef33f2f16ebf454abf1930e"

    url "https://download.jetbrains.com/idea/ideaIC-#{version}.dmg"
  else
    sha256 "bbca5e4c8de546bfc701830ebce14cf6cef85f28b003a196dae584d7ad9165ae"

    url "https://download.jetbrains.com/idea/ideaIC-#{version}-aarch64.dmg"
  end

  name "IntelliJ IDEA Community Edition"
  name "IntelliJ IDEA CE"
  desc "IDE for Java development - community edition"
  homepage "https://www.jetbrains.com/idea/"

  livecheck do
    url "https://data.services.jetbrains.com/products/releases?code=IIC&latest=true&type=release"
    strategy :page_match
    regex(%r{/ideaIC-(\d+(?:\.\d+)*)\.dmg}i)
  end

  auto_updates true
  conflicts_with cask: "homebrew/cask-versions/intellij-idea-ce19"

  app "IntelliJ IDEA CE.app"

  uninstall_postflight do
    ENV["PATH"].split(File::PATH_SEPARATOR).map { |path| File.join(path, "idea") }.each do |path|
      if File.exist?(path) &&
         File.readlines(path).grep(/# see com.intellij.idea.SocketLock for the server side of this interface/).any?
        File.delete(path)
      end
    end
  end

  zap trash: [
    "~/Library/Application Support/JetBrains/IdeaIC#{version.major_minor}",
    "~/Library/Caches/JetBrains/IdeaIC#{version.major_minor}",
    "~/Library/Logs/JetBrains/IdeaIC#{version.major_minor}",
    "~/Library/Preferences/com.jetbrains.intellij.ce.plist",
    "~/Library/Saved Application State/com.jetbrains.intellij.ce.savedState",
  ]
end
