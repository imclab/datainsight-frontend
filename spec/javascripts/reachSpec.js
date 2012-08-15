describe("reach", function() {
    describe("axes labels", function() {
        describe("tick values for y axes", function() {
            it("should produce correct tick values", function() {
                expect(get_tick_values([2100, 3400, 1000, 2300, 5000, 6000, 3000], 3)).toEqual([0, 3000, 6000]);
            });

            it("should produce correct tick values", function() {
                expect(get_tick_values([2100, 3400, 1000, 2300, 80000, 6000, 3000, 60000, 34900], 6)).toEqual([ 0, 16000, 32000, 48000, 64000, 80000 ]);
            });
        });
    });

    describe("data to plot", function() {
        it("should concatenate today and yesterdays data correctly", function() {
            expect(get_data_to_plot([90,89,78], [34,45,56,78,89,90,12])).toEqual([90,89,78,78,89,90,12]);
        })
    })

    describe("Y-Axis formatting", function(){
        it("should return the same number as string if max value is below one thousand", function(){
            expect(format_tick_label(100, 800)).toEqual("100");
        })

        it("should return value in thousands if max value is between one thousand and one million", function(){
            expect(format_tick_label(10000, 80000)).toEqual("10k");
        })

        it("should return value in millions if max value is above one million", function(){
            expect(format_tick_label(1000000, 8000000)).toEqual("1m");
        })
    })
});