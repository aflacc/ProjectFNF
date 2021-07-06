if (stepping) { // runs every step
    switch (stepShit) {
    }
} else { // runs every beat
    switch (beatShit) {
        case 4:
            for (note in 0...strumLineNotes.members.length) {
                ModCharts.circleLoop(strumLineNotes.members[note], 20, 3);
            }
        case 8:
            for (note in 0...strumLineNotes.members.length) {
                ModCharts.cancelMovement(strumLineNotes.members[note]);
            }
        case 12:
            for (note in 0...strumLineNotes.members.length) {
                ModCharts.circleLoop(strumLineNotes.members[note], 20, 3);
            }
        case 16:
            for (note in 0...strumLineNotes.members.length) {
                ModCharts.cancelMovement(strumLineNotes.members[note]);
            }
    }
}