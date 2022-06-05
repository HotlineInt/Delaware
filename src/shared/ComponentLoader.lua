return function(ComponentFolder : Folder)
    for _,Component in pairs(ComponentFolder:GetChildren()) do
        require(Component)
    end
end
