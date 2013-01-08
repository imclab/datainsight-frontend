describe("SVG helpers", function() {
    describe("translate", function() {
        it("should generate a translate directive", function() {
            expect(GOVUK.Insights.translate(0, 0)).toEqual("translate(0,0)");
            expect(GOVUK.Insights.translate(13.4, -67.25)).toEqual("translate(13.4,-67.25)");
        });
    });

});