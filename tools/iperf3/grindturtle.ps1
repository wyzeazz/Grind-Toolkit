# Grind the Turtle - Temple of Echo
# Chapter 1: PowerShell Edition

# Data file
$SaveFile = "$env:USERPROFILE\Desktop\temple_data.json"

# Default state
$State = @{
    compass_glyph = 0
    footsteps_glyph = 0
    eye_glyph = 0
    cursed_shards = 0
    risky_choices = 0
    path1_attempted = 0
    path2_attempted = 0
    path3_attempted = 0
    help_shown = 0
}

# Load save
if (Test-Path $SaveFile) {
    try {
        $Loaded = Get-Content $SaveFile -Raw | ConvertFrom-Json
        $State.compass_glyph = $Loaded.compass_glyph
        $State.footsteps_glyph = $Loaded.footsteps_glyph
        $State.eye_glyph = $Loaded.eye_glyph
        $State.cursed_shards = $Loaded.cursed_shards
        $State.risky_choices = $Loaded.risky_choices
        $State.path1_attempted = $Loaded.path1_attempted
        $State.path2_attempted = $Loaded.path2_attempted
        $State.path3_attempted = $Loaded.path3_attempted
        $State.help_shown = $Loaded.help_shown
    } catch {
        Write-Host "Save file corrupted. Starting fresh." -ForegroundColor Yellow
        Start-Sleep -Seconds 2
    }
}

function Save-Game {
    $State | ConvertTo-Json | Set-Content $SaveFile
}

function Pause-Moment {
    Write-Host ""
    Write-Host "Press Enter to continue..."
    $null = Read-Host
}

function Show-Inventory {
    Clear-Host
    Write-Host ""
    Write-Host "========================================"
    Write-Host "           YOUR INVENTORY"
    Write-Host "========================================"
    Write-Host ""
    Write-Host "Directory: Inventory:\"
    Write-Host ""
    if ($State.compass_glyph -eq 1) { Write-Host "--a-    Compass_Glyph" }
    if ($State.footsteps_glyph -eq 1) { Write-Host "--a-    Footstep_Glyph" }
    if ($State.eye_glyph -eq 1) { Write-Host "--a-    Eye_Glyph" }
    if ($State.cursed_shards -gt 0) { Write-Host "--a-    Cursed_Shard x$($State.cursed_shards)" }
    if ($State.compass_glyph -eq 0 -and $State.footsteps_glyph -eq 0 -and $State.eye_glyph -eq 0 -and $State.cursed_shards -eq 0) {
        Write-Host "[empty]"
    }
    Write-Host ""
    Pause-Moment
}

function Show-Help {
    Clear-Host
    Write-Host ""
    Write-Host "========================================"
    Write-Host "              HELP"
    Write-Host "========================================"
    Write-Host ""
    Write-Host "Available commands:"
    Write-Host "  dir                    - Show available paths"
    Write-Host "  cd [pathname]          - Enter a path"
    Write-Host "  dir Inventory:\        - Show your collected items"
    Write-Host "  Get-Location           - Find where you are"
    Write-Host "  Get-ChildItem          - See what is here"
    Write-Host "  Copy-Item              - Copy an item"
    Write-Host "  Move-Item              - Move an item"
    Write-Host "  boss                   - Face the Shifting Echo"
    Write-Host "  quit                   - Save and exit"
    Write-Host ""
    Write-Host "The Echo: 'Help will not save you in the boss fight.'"
    Pause-Moment
}

# PATH 1: COMPASS
function Enter-CompassPath {
    if ($State.compass_glyph -eq 1) {
        Write-Host "You have already mastered this path."
        Pause-Moment
        return
    }
    if ($State.path1_attempted -eq 1) {
        Write-Host "You walked this path once. It will not open again."
        Pause-Moment
        return
    }

    Clear-Host
    Write-Host ""
    Write-Host "========================================"
    Write-Host "        PATH OF THE COMPASS"
    Write-Host "========================================"
    Write-Host ""
    Write-Host "You step through the doorway. The air grows still."
    Write-Host "A round chamber opens before you. A floating map pulses at the center."
    Write-Host "Your location on the map is blank — as if you do not exist."
    Write-Host ""
    Write-Host 'The Echo (amused): "To find yourself, you must ask where you are."'
    Write-Host ""
    Pause-Moment

    # LESSON 1: Get-Location
    Clear-Host
    Write-Host ""
    Write-Host "========================================"
    Write-Host "        LESSON 1: WHERE YOU STAND"
    Write-Host "========================================"
    Write-Host ""
    Write-Host 'The Echo: "The old scholars asked a question of the earth itself."'
    Write-Host '"Where do you stand? How would you ask that?"'
    Write-Host ""
    $solved = $false
    while (-not $solved) {
        $cmd = Read-Host '> '
        if ($cmd -eq 'dir') {
            Write-Host ""
            Write-Host "Directory of Chamber_of_Compass"
            Write-Host ""
            Write-Host "--a-    Floating_Map"
            Write-Host "--a-    Empty_Pedestal"
            Write-Host ""
            Write-Host 'The Echo: "The map shows nothing. You must reveal your location."'
        }
        elseif ($cmd -eq 'Get-Location') {
            Write-Host ""
            Write-Host "The map blazes to life."
            Write-Host "Current location: Chamber_of_Compass"
            Write-Host ""
            Write-Host 'The Echo: "Good. You know where you stand."'
            Write-Host "A faint warmth spreads through your chest."
            $solved = $true
        }
        elseif ($cmd -eq 'pwd') {
            Write-Host ""
            Write-Host 'The Echo: "pwd? The old tongue. Some still speak it. Try Get-Location instead."'
        }
        else {
            Write-Host ""
            Write-Host 'The Echo: "No. That is not the way."'
        }
        if (-not $solved) { Write-Host "" }
    }
    Pause-Moment

    # LESSON 2: Copy-Item
    Clear-Host
    Write-Host ""
    Write-Host "========================================"
    Write-Host "        LESSON 2: COPYING WISDOM"
    Write-Host "========================================"
    Write-Host ""
    Write-Host "A second map appears beside the first. It is faded, ancient."
    Write-Host "Its ink has bled into parchment over centuries."
    Write-Host ""
    Write-Host 'The Echo: "Wisdom is copied, not stolen. Duplicate the map."'
    Write-Host '"The command is two words. First: Copy. Second: what you copy and what you name it."'
    Write-Host ""
    $copied = $false
    while (-not $copied) {
        $cmd = Read-Host '> '
        if ($cmd -eq 'Copy-Item Floating_Map New_Map') {
            Write-Host ""
            Write-Host "You copy the map. The new map shimmers with impossible clarity."
            Write-Host ""
            Write-Host "Directory of Chamber_of_Compass"
            Write-Host ""
            Write-Host "d---    Temple_Entrance"
            Write-Host "d---    Void_Well"
            Write-Host ""
            Write-Host 'The Echo: "Two paths. One leads to wisdom. One leads to hunger."'
            $copied = $true
        }
        elseif ($cmd -eq 'dir') {
            Write-Host ""
            Write-Host "Directory of Chamber_of_Compass"
            Write-Host ""
            Write-Host "--a-    Floating_Map"
            Write-Host "--a-    Empty_Pedestal"
        }
        else {
            Write-Host ""
            Write-Host 'The Echo: "The map does not copy. Try Copy-Item Floating_Map New_Map"'
        }
        if (-not $copied) { Write-Host "" }
    }
    Pause-Moment

    # LESSON 3: cd to choose (branch)
    Clear-Host
    Write-Host ""
    Write-Host "========================================"
    Write-Host "        LESSON 3: CHOOSING YOUR PATH"
    Write-Host "========================================"
    Write-Host ""
    Write-Host 'The Echo: "Type cd followed by a destination to move."'
    Write-Host '"Your choice will change you."'
    Write-Host ""
    $chosen = $false
    while (-not $chosen) {
        $cmd = Read-Host '> '
        if ($cmd -eq 'cd Temple_Entrance') {
            Write-Host ""
            Write-Host "You step toward the Temple_Entrance. Warm light washes over you."
            Write-Host 'The Echo: "Wisdom. The Compass Glyph is yours."'
            Write-Host "The glyph sinks into your chest. You feel... oriented. Grounded."
            $State.compass_glyph = 1
            $State.path1_attempted = 1
            Save-Game
            $chosen = $true
        }
        elseif ($cmd -eq 'cd Void_Well') {
            Write-Host ""
            Write-Host "You step toward the Void_Well. Cold dread fills your lungs."
            Write-Host 'The Echo (disappointed): "Hunger. The void stares back."'
            Write-Host "A cursed shard attaches to your shell. It twitches. You regret touching it."
            $State.cursed_shards++
            $State.risky_choices++
            $State.path1_attempted = 1
            Save-Game
            $chosen = $true
        }
        elseif ($cmd -eq 'dir') {
            Write-Host ""
            Write-Host "Directory of Chamber_of_Compass"
            Write-Host ""
            Write-Host "d---    Temple_Entrance"
            Write-Host "d---    Void_Well"
        }
        else {
            Write-Host ""
            Write-Host 'The Echo: "That is not a destination. Type dir to see where you can go."'
        }
        if (-not $chosen) { Write-Host "" }
    }
    Pause-Moment

    Write-Host ""
    Write-Host 'The Echo: "You have learned the Path of the Compass."'
    if ($State.compass_glyph -eq 1) {
        Write-Host "The glyph inside you glows faintly."
    } else {
        Write-Host "The cursed shard whispers. You wonder what could have been."
    }
    Write-Host "Return to the Central Chamber."
    Pause-Moment
}

# PATH 2: FOOTSTEPS
function Enter-FootstepsPath {
    if ($State.footsteps_glyph -eq 1) {
        Write-Host "You have already mastered this path."
        Pause-Moment
        return
    }
    if ($State.path2_attempted -eq 1) {
        Write-Host "You walked this path once. It will not open again."
        Pause-Moment
        return
    }

    Clear-Host
    Write-Host ""
    Write-Host "========================================"
    Write-Host "       PATH OF THE FOOTSTEPS"
    Write-Host "========================================"
    Write-Host ""
    Write-Host "You step through the doorway. The floor shifts beneath you."
    Write-Host "A long corridor stretches forward. Three archways."
    Write-Host ""
    Write-Host 'The Echo: "To move is to exist. Change where you are."'
    Write-Host ""
    Pause-Moment

    # LESSON 1: dir to see doors
    Clear-Host
    Write-Host ""
    Write-Host "========================================"
    Write-Host "        LESSON 1: SEEING DOORS"
    Write-Host "========================================"
    Write-Host ""
    Write-Host 'The Echo: "Look around. See what is here."'
    Write-Host ""
    $dirred = $false
    while (-not $dirred) {
        $cmd = Read-Host '> '
        if ($cmd -eq 'dir') {
            Write-Host ""
            Write-Host "Directory of Corridor_of_Doors"
            Write-Host ""
            Write-Host "d---    Echo_Hall"
            Write-Host "d---    Mirror_Room"
            Write-Host "d---    Abyss"
            Write-Host ""
            Write-Host 'The Echo: "Three doors. Three destinations. Choose."'
            $dirred = $true
        }
        else {
            Write-Host ""
            Write-Host 'The Echo: "Try dir to see what is here."'
        }
        if (-not $dirred) { Write-Host "" }
    }
    Pause-Moment

    # LESSON 2: cd to enter
    Clear-Host
    Write-Host ""
    Write-Host "========================================"
    Write-Host "        LESSON 2: ENTERING A ROOM"
    Write-Host "========================================"
    Write-Host ""
    Write-Host 'The Echo: "Type cd followed by a door name to enter."'
    Write-Host ""
    $entered = $false
    while (-not $entered) {
        $cmd = Read-Host '> '
        if ($cmd -eq 'cd Echo_Hall') {
            Write-Host ""
            Write-Host "You enter the Echo_Hall. Your footsteps repeat behind you."
            Write-Host "The sound is unsettling. You are not alone here."
            $entered = $true
        }
        elseif ($cmd -eq 'cd Mirror_Room') {
            Write-Host ""
            Write-Host "You step into the Mirror_Room. Infinite reflections stare back."
            Write-Host "They all look afraid. You cannot tell which one is real."
            Write-Host 'The Echo (cold): "You are lost. A cursed shard clings to you."'
            $State.cursed_shards++
            $State.risky_choices++
            $State.path2_attempted = 1
            Save-Game
            Pause-Moment
            return
        }
        elseif ($cmd -eq 'cd Abyss') {
            Write-Host ""
            Write-Host "You step into the Abyss. The floor vanishes. You fall."
            Write-Host "The wind screams past your ears. You fall for an eternity."
            Write-Host 'The Echo (distant): "The Abyss has no bottom. A cursed shard in your grip."'
            $State.cursed_shards++
            $State.risky_choices++
            $State.path2_attempted = 1
            Save-Game
            Pause-Moment
            return
        }
        elseif ($cmd -eq 'dir') {
            Write-Host ""
            Write-Host "Directory of Corridor_of_Doors"
            Write-Host ""
            Write-Host "d---    Echo_Hall"
            Write-Host "d---    Mirror_Room"
            Write-Host "d---    Abyss"
        }
        else {
            Write-Host ""
            Write-Host 'The Echo: "That door does not exist. Type dir to see doors."'
        }
        if (-not $entered) { Write-Host "" }
    }
    Pause-Moment

    # LESSON 3: cd .. to go back
    Clear-Host
    Write-Host ""
    Write-Host "========================================"
    Write-Host "        LESSON 3: GOING BACK"
    Write-Host "========================================"
    Write-Host ""
    Write-Host 'The Echo: "You are in the Echo_Hall."'
    Write-Host '"To go back, type cd space dot dot."'
    Write-Host ""
    $back = $false
    while (-not $back) {
        $cmd = Read-Host '> '
        if ($cmd -eq 'cd ..') {
            Write-Host ""
            Write-Host "You return to the corridor. The echoing stops."
            Write-Host 'The Echo: "Good. The Footstep Glyph is yours."'
            Write-Host "The glyph settles into your leg. You feel lighter. Faster."
            $State.footsteps_glyph = 1
            $State.path2_attempted = 1
            Save-Game
            $back = $true
        }
        elseif ($cmd -eq 'dir') {
            Write-Host ""
            Write-Host "Directory of Echo_Hall"
            Write-Host ""
            Write-Host "d---    .."
            Write-Host "--a-    Echoing_Whisper"
            Write-Host ""
            Write-Host 'The Echo: ".. means parent directory. Type cd .. to go back."'
        }
        else {
            Write-Host ""
            Write-Host 'The Echo: "You are still in Echo_Hall. Try cd .."'
        }
        if (-not $back) { Write-Host "" }
    }
    Pause-Moment

    # LESSON 4: Move-Item
    Clear-Host
    Write-Host ""
    Write-Host "========================================"
    Write-Host "        LESSON 4: MOVING OBSTACLES"
    Write-Host "========================================"
    Write-Host ""
    Write-Host "A massive boulder blocks the exit. It is carved with old warnings."
    Write-Host ""
    Write-Host 'The Echo: "Move it. The command is two words. First: Move. Second: what and where."'
    Write-Host ""
    $moved = $false
    while (-not $moved) {
        $cmd = Read-Host '> '
        if ($cmd -eq 'Move-Item Boulder Exit_Path') {
            Write-Host ""
            Write-Host "The boulder groans. It rolls aside. The path is clear."
            Write-Host ""
            Write-Host 'The Echo: "You have learned to move obstacles."'
            $moved = $true
        }
        else {
            Write-Host ""
            Write-Host 'The Echo: "The boulder does not move. Try Move-Item Boulder Exit_Path"'
        }
        if (-not $moved) { Write-Host "" }
    }
    Pause-Moment

    Write-Host ""
    Write-Host 'The Echo: "You have learned the Path of the Footsteps."'
    if ($State.footsteps_glyph -eq 1) {
        Write-Host "Your legs remember now. You could run forever."
    } else {
        Write-Host "The cursed shard weighs you down. You walk heavier than before."
    }
    Write-Host "Return to the Central Chamber."
    Pause-Moment
}

# PATH 3: EYE
function Enter-EyePath {
    if ($State.eye_glyph -eq 1) {
        Write-Host "You have already mastered this path."
        Pause-Moment
        return
    }
    if ($State.path3_attempted -eq 1) {
        Write-Host "You walked this path once. It will not open again."
        Pause-Moment
        return
    }

    Clear-Host
    Write-Host ""
    Write-Host "========================================"
    Write-Host "          PATH OF THE EYE"
    Write-Host "========================================"
    Write-Host ""
    Write-Host "You step through the doorway. The world vanishes."
    Write-Host "You stand in a vault of shadows. Pedestals everywhere."
    Write-Host "But you cannot see what they hold."
    Write-Host ""
    Write-Host 'The Echo: "To see what hides, use Get-ChildItem."'
    Write-Host ""
    Pause-Moment

    # LESSON 1: dir to see visible
    Clear-Host
    Write-Host ""
    Write-Host "========================================"
    Write-Host "        LESSON 1: SEEING THE VISIBLE"
    Write-Host "========================================"
    Write-Host ""
    Write-Host 'The Echo: "Look around. See what is here."'
    Write-Host ""
    $dirred = $false
    while (-not $dirred) {
        $cmd = Read-Host '> '
        if ($cmd -eq 'dir') {
            Write-Host ""
            Write-Host "Directory of Vault_of_Shadows"
            Write-Host ""
            Write-Host "--a-    Crystal_Skull"
            Write-Host "--a-    Stone_Tablet"
            Write-Host "--a-    Golden_Chalice"
            Write-Host ""
            Write-Host 'The Echo: "You see what is visible. But some things hide."'
            $dirred = $true
        }
        elseif ($cmd -eq 'Get-ChildItem') {
            Write-Host ""
            Write-Host "Directory of Vault_of_Shadows"
            Write-Host ""
            Write-Host "--a-    Crystal_Skull"
            Write-Host "--a-    Stone_Tablet"
            Write-Host "--a-    Golden_Chalice"
            Write-Host ""
            Write-Host 'The Echo: "You see what is visible. But some things hide."'
            $dirred = $true
        }
        else {
            Write-Host ""
            Write-Host 'The Echo: "Try dir or Get-ChildItem"'
        }
        if (-not $dirred) { Write-Host "" }
    }
    Pause-Moment

    # LESSON 2: dir -Force to see hidden
    Clear-Host
    Write-Host ""
    Write-Host "========================================"
    Write-Host "        LESSON 2: WHAT HIDES"
    Write-Host "========================================"
    Write-Host ""
    Write-Host 'The Echo: "There is more here than you can see."'
    Write-Host '"Add -Force to your command. Force the shadows to part."'
    Write-Host ""
    $forced = $false
    while (-not $forced) {
        $cmd = Read-Host '> '
        if ($cmd -eq 'dir -Force') {
            Write-Host ""
            Write-Host "You focus deeper. The shadows tremble. They part."
            Write-Host ""
            Write-Host "Directory of Vault_of_Shadows"
            Write-Host ""
            Write-Host "--a-    Crystal_Skull"
            Write-Host "--a-    Stone_Tablet"
            Write-Host "--a-    Golden_Chalice"
            Write-Host "--ah-   Whisper_Stone"
            Write-Host ""
            Write-Host 'The Echo: "A Whisper Stone shimmers into view beneath the tablet."'
            $forced = $true
        }
        elseif ($cmd -eq 'Get-ChildItem -Force') {
            Write-Host ""
            Write-Host "You focus deeper. The shadows tremble. They part."
            Write-Host ""
            Write-Host "Directory of Vault_of_Shadows"
            Write-Host ""
            Write-Host "--a-    Crystal_Skull"
            Write-Host "--a-    Stone_Tablet"
            Write-Host "--a-    Golden_Chalice"
            Write-Host "--ah-   Whisper_Stone"
            Write-Host ""
            Write-Host 'The Echo: "A Whisper Stone shimmers into view beneath the tablet."'
            $forced = $true
        }
        else {
            Write-Host ""
            Write-Host 'The Echo: "Not that. Try dir -Force"'
        }
        if (-not $forced) { Write-Host "" }
    }
    Pause-Moment

    # LESSON 3: Copy-Item and Move-Item to claim glyph
    Clear-Host
    Write-Host ""
    Write-Host "========================================"
    Write-Host "        LESSON 3: CLAIMING THE GLYPH"
    Write-Host "========================================"
    Write-Host ""
    Write-Host 'The Echo: "The Whisper_Stone is hidden beneath the tablet."'
    Write-Host '"Copy it to a new location. Then move it to your inventory."'
    Write-Host ""
    $copied = $false
    while (-not $copied) {
        $cmd = Read-Host '> '
        if ($cmd -eq 'Copy-Item Whisper_Stone Temp_Stone') {
            Write-Host ""
            Write-Host "You copy the Whisper_Stone to Temp_Stone. It hums softly."
            $copied = $true
        }
        else {
            Write-Host ""
            Write-Host 'The Echo: "Try Copy-Item Whisper_Stone Temp_Stone"'
        }
        if (-not $copied) { Write-Host "" }
    }
    $moved = $false
    while (-not $moved) {
        $cmd = Read-Host '> '
        if ($cmd -eq 'Move-Item Temp_Stone Inventory:\') {
            Write-Host ""
            Write-Host "The Whisper_Stone becomes an Eye Glyph in your inventory."
            Write-Host "It presses into your forehead. You see through shadow now."
            Write-Host 'The Echo: "The Eye Glyph is yours."'
            $State.eye_glyph = 1
            $State.path3_attempted = 1
            Save-Game
            $moved = $true
        }
        else {
            Write-Host ""
            Write-Host 'The Echo: "Try Move-Item Temp_Stone Inventory:\"'
        }
        if (-not $moved) { Write-Host "" }
    }
    Pause-Moment

    Write-Host ""
    Write-Host 'The Echo: "You have learned the Path of the Eye."'
    if ($State.eye_glyph -eq 1) {
        Write-Host "The world seems sharper now. You notice things you missed before."
    } else {
        Write-Host "The cursed shard pulses near your temple. Your vision blurs at the edges."
    }
    Write-Host "Return to the Central Chamber."
    Pause-Moment
}

# BOSS FIGHT
function Enter-BossFight {
    $total = $State.compass_glyph + $State.footsteps_glyph + $State.eye_glyph
    if ($total -eq 0) {
        Clear-Host
        Write-Host ""
        Write-Host "You approach the door. It does not move."
        Write-Host 'The Echo: "You have learned nothing. Walk my halls first."'
        Pause-Moment
        return
    }

    Clear-Host
    Write-Host ""
    Write-Host "========================================"
    Write-Host "         THE SHIFTING ECHO"
    Write-Host "========================================"
    Write-Host ""
    Write-Host "The door grinds open. Darkness breathes out."
    Write-Host "A figure coalesces from shadow. Tall. Featureless. Its edges never still."
    Write-Host ""
    Write-Host '"You have learned. But can you move under pressure?"'
    Write-Host ""
    Pause-Moment

    $stolen = $false
    $stolen_type = ""

    # PHASE 1: STEAL
    Clear-Host
    Write-Host ""
    Write-Host "========================================"
    Write-Host "        PHASE 1: THE STEAL"
    Write-Host "========================================"
    Write-Host ""
    Write-Host 'The Echo reaches into you. Its fingers are cold.'

    if ($State.compass_glyph -eq 1 -and -not $stolen) {
        $stolen = $true
        $stolen_type = "compass"
        $State.compass_glyph = 0
        Write-Host "Your Compass Glyph tears free from your chest and vanishes behind a door."
    }
    elseif ($State.footsteps_glyph -eq 1 -and -not $stolen) {
        $stolen = $true
        $stolen_type = "footsteps"
        $State.footsteps_glyph = 0
        Write-Host "Your Footstep Glyph rips from your leg and vanishes behind a door."
    }
    elseif ($State.eye_glyph -eq 1 -and -not $stolen) {
        $stolen = $true
        $stolen_type = "eye"
        $State.eye_glyph = 0
        Write-Host "Your Eye Glyph pulls from your forehead and vanishes behind a door."
    }

    if ($stolen) {
        Write-Host ""
        Write-Host 'The Echo: "Re-earn what I took. Ask where you are."'
        Write-Host ""
        $reearned = $false
        while (-not $reearned) {
            $cmd = Read-Host '> '
            if ($cmd -eq 'Get-Location') {
                Write-Host ""
                Write-Host "You are in the Shifting Sanctum. The glyph returns to you."
                if ($stolen_type -eq "compass") { $State.compass_glyph = 1 }
                if ($stolen_type -eq "footsteps") { $State.footsteps_glyph = 1 }
                if ($stolen_type -eq "eye") { $State.eye_glyph = 1 }
                Save-Game
                Write-Host "The Echo staggers. Phase one complete."
                $reearned = $true
            }
            else {
                Write-Host ""
                Write-Host 'The Echo: "No. Ask where you stand."'
            }
            if (-not $reearned) { Write-Host "" }
        }
    }
    else {
        Write-Host 'The Echo: "You have nothing left to steal? Curious."'
    }
    Pause-Moment

    # PHASE 2: MIRROR
    Clear-Host
    Write-Host ""
    Write-Host "========================================"
    Write-Host "        PHASE 2: THE MIRROR"
    Write-Host "========================================"
    Write-Host ""
    Write-Host "The Echo splits. A copy of you stands opposite."
    Write-Host "It mirrors every cd command you type."
    Write-Host ""
    Write-Host 'The Echo: "Lead it into the Trap_Room. Move there."'
    Write-Host ""
    $led = $false
    while (-not $led) {
        $cmd = Read-Host '> '
        if ($cmd -eq 'cd Trap_Room') {
            Write-Host ""
            Write-Host "You step into the Trap_Room. Walls of broken glass reflect infinity."
            Write-Host "The copy follows, sees itself a thousand times, and shatters."
            Write-Host "Phase two complete."
            $led = $true
        }
        else {
            Write-Host ""
            Write-Host "The copy follows: $cmd"
        }
        if (-not $led) { Write-Host "" }
    }
    Pause-Moment

    # PHASE 3: BLOCK
    Clear-Host
    Write-Host ""
    Write-Host "========================================"
    Write-Host "        PHASE 3: THE BLOCK"
    Write-Host "========================================"
    Write-Host ""
    Write-Host 'The Echo drops a Blocked_Path across your exit.'
    Write-Host 'The Echo: "Remove it. Clear the way."'
    Write-Host ""
    $cleared = $false
    while (-not $cleared) {
        $cmd = Read-Host '> '
        if ($cmd -eq 'Remove-Item Blocked_Path') {
            Write-Host ""
            Write-Host "The block shatters. The path clears."
            Write-Host "Phase three complete."
            $cleared = $true
        }
        else {
            Write-Host ""
            Write-Host 'The Echo: "The block remains. Remove-Item Blocked_Path"'
        }
        if (-not $cleared) { Write-Host "" }
    }
    Pause-Moment

    # PHASE 4: ALL THREE
    Clear-Host
    Write-Host ""
    Write-Host "========================================"
    Write-Host "     FINAL PHASE: THE ECHO UNLEASHED"
    Write-Host "========================================"
    Write-Host ""
    Write-Host "Steal. Mirror. Block. All at once."
    Write-Host ""
    Write-Host '"Survive this, and the Power Shell is yours."'
    Write-Host ""

    Write-Host 'Step 1: Find the stolen glyph. Ask where you are.'
    $step1 = $false
    while (-not $step1) {
        $cmd = Read-Host '> '
        if ($cmd -eq 'Get-Location') {
            Write-Host ""
            Write-Host "You sense the glyph in the Glyph_Room."
            $step1 = $true
        }
        else {
            Write-Host ""
            Write-Host 'The Echo: "Wrong. Ask where you stand."'
        }
        if (-not $step1) { Write-Host "" }
    }

    Write-Host ""
    Write-Host 'Step 2: Navigate to it. Move there.'
    $step2 = $false
    while (-not $step2) {
        $cmd = Read-Host '> '
        if ($cmd -eq 'cd Glyph_Room') {
            Write-Host ""
            Write-Host "You enter. The glyph floats before you."
            $step2 = $true
        }
        else {
            Write-Host ""
            Write-Host 'The Echo: "Wrong room. Move there."'
        }
        if (-not $step2) { Write-Host "" }
    }

    Write-Host ""
    Write-Host 'Step 3: Clear the block. Remove it.'
    $step3 = $false
    while (-not $step3) {
        $cmd = Read-Host '> '
        if ($cmd -eq 'Remove-Item Block') {
            Write-Host ""
            Write-Host "The glyph returns. The Echo screams and dissolves into light."
            $step3 = $true
        }
        else {
            Write-Host ""
            Write-Host 'The Echo: "The block holds. Remove-Item Block"'
        }
        if (-not $step3) { Write-Host "" }
    }
    Pause-Moment

    # Check for secret skateboard ending
    $total_glyphs = $State.compass_glyph + $State.footsteps_glyph + $State.eye_glyph
    if ($State.cursed_shards -ge 3 -and $State.risky_choices -eq 3 -and $total_glyphs -eq 0) {
        Clear-Host
        Write-Host ""
        Write-Host "========================================"
        Write-Host "       SECRET SKATEBOARD ENDING"
        Write-Host "========================================"
        Write-Host ""
        Write-Host "The cursed energy inside you resonates with the temple."
        Write-Host "The Echo pauses. 'What... what ARE you?'"
        Write-Host ""
        Write-Host "A hidden door opens. Inside: a RADICAL SKATEBOARD."
        Write-Host ""
        Write-Host "You kickflip off the Echo's head. It stares, confused."
        Write-Host "You ride through the temple at impossible speed."
        Write-Host "Walls blur. Time warps. The Echo tries to follow and wipes out."
        Write-Host ""
        Write-Host "You burst into daylight, surfing on pure chaos."
        Write-Host "WHO NEEDS A POWER SHELL WHEN YOU HAVE STYLE?"
        Write-Host ""
        Write-Host "Rank: Radical"
        Pause-Moment
        return
    }

    # Victory ending
    Clear-Host
    Write-Host ""
    Write-Host "========================================"
    Write-Host "              VICTORY"
    Write-Host "========================================"
    Write-Host ""
    Write-Host "The Shifting Echo crumbles into light."
    Write-Host ""
    Write-Host "A Power Shell descends from above. Glowing. Warm. Perfect."
    Write-Host "It snaps into place on your back."
    Write-Host "You are no longer a naked turtle."
    Write-Host ""
    $total = $State.compass_glyph + $State.footsteps_glyph + $State.eye_glyph
    Write-Host "You completed with $total/3 glyphs and $($State.cursed_shards) cursed shards."
    Write-Host ""
    Write-Host "Grind the Turtle - Chapter 1 Complete."
    Write-Host "Rank: Echo Breaker"
    Pause-Moment
}

# ============================================
# MAIN GAME LOOP
# ============================================
Clear-Host
Write-Host ""
Write-Host "========================================"
Write-Host "     GRIND THE TURTLE - TEMPLE OF ECHO"
Write-Host "           Chapter 1"
Write-Host "========================================"
Write-Host ""
Write-Host "You wake on cold stone. Jungle canopy above."
Write-Host "Your brain is foggy. Your back is sore."
Write-Host "Wait — where's your power shell? Stolen."
Write-Host ""
Write-Host "You remember nothing. Only your name: Grind."
Write-Host ""
Write-Host "Ahead, ancient doors carved with three symbols:"
Write-Host "a compass, a footprint, an eye."
Write-Host ""
Write-Host 'A voice echoes from within, old and dry as dust:'
Write-Host ""
Write-Host '"Enter, amnesiac. Walk my halls."'
Write-Host '"Learn the commands you have forgotten."'
Write-Host '"Or be lost here forever."'
Write-Host ""
Write-Host "The Echo knows something you don't."
Write-Host "You stand. You step forward."
Write-Host ""
Pause-Moment

while ($true) {
    Clear-Host
    Write-Host ""
    Write-Host "========================================"
    Write-Host "         CENTRAL CHAMBER"
    Write-Host "========================================"
    Write-Host ""
    Write-Host "Type 'dir' to see what paths are available."
    Write-Host "Type 'help' for commands."
    Write-Host ""
    
    # Show help reminder first time only
    if ($State.help_shown -eq 0) {
        Write-Host ""
        Write-Host 'The Echo: "Type help to see what you can do."'
        Write-Host 'The Echo: "I will not say this again."'
        Write-Host ""
        $State.help_shown = 1
        Save-Game
    }
    
    $cmd = Read-Host '> '
    
    if ($cmd -eq 'dir') {
        Clear-Host
        Write-Host ""
        Write-Host "========================================"
        Write-Host "         TEMPLE DIRECTORIES"
        Write-Host "========================================"
        Write-Host ""
        Write-Host "Directory of Central_Chamber"
        Write-Host ""
        if ($State.compass_glyph -eq 1) { Write-Host "d---    Compass_Path [MASTERED]" }
        elseif ($State.path1_attempted -eq 1) { Write-Host "d---    Compass_Path [CORRUPTED]" }
        else { Write-Host "d---    Compass_Path" }
        if ($State.footsteps_glyph -eq 1) { Write-Host "d---    Footsteps_Path [MASTERED]" }
        elseif ($State.path2_attempted -eq 1) { Write-Host "d---    Footsteps_Path [CORRUPTED]" }
        else { Write-Host "d---    Footsteps_Path" }
        if ($State.eye_glyph -eq 1) { Write-Host "d---    Eye_Path [MASTERED]" }
        elseif ($State.path3_attempted -eq 1) { Write-Host "d---    Eye_Path [CORRUPTED]" }
        else { Write-Host "d---    Eye_Path" }
        Write-Host ""
        $total = $State.compass_glyph + $State.footsteps_glyph + $State.eye_glyph
        Write-Host "Glyphs: $total/3"
        if ($State.cursed_shards -gt 0) { Write-Host "Cursed shards: $($State.cursed_shards)" }
        Write-Host ""
        Write-Host 'The Echo: "Type cd followed by a path name to enter."'
        Write-Host ""
        Pause-Moment
        continue
    }
    
    if ($cmd -eq 'ls') { continue }
    if ($cmd -eq 'Get-ChildItem') { continue }
    
    if ($cmd -eq 'dir Inventory:\' -or $cmd -eq 'ls Inventory:\') {
        Show-Inventory
        continue
    }
    
    if ($cmd -eq 'cd Compass_Path') {
        Enter-CompassPath
        continue
    }
    
    if ($cmd -eq 'cd Footsteps_Path') {
        Enter-FootstepsPath
        continue
    }
    
    if ($cmd -eq 'cd Eye_Path') {
        Enter-EyePath
        continue
    }
    
    if ($cmd -eq 'boss') {
        Enter-BossFight
        continue
    }
    
    if ($cmd -eq 'help') {
        Show-Help
        continue
    }
    
    if ($cmd -eq 'quit') {
        Write-Host ""
        Write-Host "Your journey pauses. The Echo waits."
        Write-Host "Progress saved."
        Save-Game
        exit
    }
    
    Write-Host ""
    Write-Host 'The Echo: "I do not understand that command."'
    Write-Host 'Type "help" for available commands.'
    Write-Host ""
    Pause-Moment
}