local GuiLibrary = shared.GuiLibrary;
local wingui = {
    windows = {
        combat = GuiLibrary.ObjectsThatCanBeSaved.CombatWindow.Api.CreateOptionsButton,
        blatant = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton,
        render = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton,
        utility = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton,
        world = GuiLibrary.ObjectsThatCanBeSaved.WorldWindow.Api.CreateOptionsButton,
        exploit = GuiLibrary.ObjectsThatCanBeSaved.ExploitWindow.Api.CreateOptionsButton
    }
}

return wingui