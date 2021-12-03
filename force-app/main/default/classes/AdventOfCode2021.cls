public with sharing class AdventOfCode2021 {
    
    public static integer exercise01_raw(integer part){
        List<Integer> depthList = getExerciseList_exercise01();
        if(part == 1){
            Integer increasedCount = 0;
            for(Integer i = 0; i < depthList.size(); i++){
                if(i>0 && depthList[i] > depthList[i-1]){
                    increasedCount++;
                }
            }
            return increasedCount;
        } else if (part == 2){
            Integer increasedCount = 0;
            for(Integer i = 0; i < depthList.size(); i++){
                if(i < depthList.size() - 3){
                    Integer valueA = depthList[i] + depthList[i+1] + depthList[i+2];
                    Integer valueB = depthList[i+1] + depthList[i+2] + depthList[i+3];
                    if(valueB > valueA){
                        increasedCount++;    
                    }
                }
            } 
            return increasedCount; 
        } else {
            return null;
        }
        
    }
    
    public static integer exercise01_refactored(integer window){
        Integer increasedCount = 0;
        Integer summedValueA;
        Integer summedValueB;
        
        List<Integer> depthList = getExerciseList_exercise01();
        for(Integer i = 0; i < depthList.size(); i++){
            if(i < depthList.size() - window){
                summedValueA = summedValueB = 0;
                for(Integer j = 0; j < window; j++){
                    summedValueA += depthList[i + j];
                    summedValueB += depthlist[i+1 + j];
                }
                if(summedValueB > summedValueA){
                    increasedCount++;
                }
            }
        } 
        return increasedCount;
    }
    
    public static Integer exercise02_raw(integer part){
        if(part == 1){
            Map<String, List<Integer>> exerciseMap = getExerciseMap_exercise02();
            //depth position
            Integer depth = 0;
            for(Integer up : exerciseMap.get('up')){
                depth -= up;
            }
            for(Integer down : exerciseMap.get('down')){
                depth += down;
            }
            //horizontal position
            Integer horizontal = 0;
            for(Integer forward : exerciseMap.get('forward')){
                horizontal += forward;
            }
            return depth*horizontal;
        } else if (part == 2) {
            Integer depth = 0;
            Integer horizontal = 0;
            Integer aim = 0;
            List<String> exerciseRawList = getExerciseList_exercise02_raw();
            for(String command : exerciseRawList){
                String direction = command.split(' ')[0];
                Integer value = Integer.valueOf(command.split(' ')[1]);
                switch on direction {
                    when 'forward'{
                        horizontal += value;
                        depth += (aim * value);
                    }
                    when 'down'{
                        aim += value;
                    }
                    when 'up' {
                        aim -= value;
                    }
                    when else {
                        system.debug('Critical error, wrong values found in map:'); 
                        system.debug('direction = ' + direction + ' & value = ' + value);
                        return null;
                    }
                }
            }
            return depth*horizontal;
        } else {
            return null;
        }
    }
    
    public static integer exercise02_refactored(boolean useAim){
        Integer depth = 0;
        Integer horizontal = 0;
        Integer aim = 0;
        List<String> exerciseRawList = getExerciseList_exercise02_raw();
        for(String command : exerciseRawList){
            String direction = command.split(' ')[0];
            Integer value = Integer.valueOf(command.split(' ')[1]);
            switch on direction {
                when 'forward'{
                    horizontal += value;
                    if(useAim) depth += (aim * value);
                }
                when 'down'{
                    if(useAim) aim += value;
                    if(!useAim) depth += value;
                }
                when 'up' {
                    if(useAim) aim -= value;
                    if(!useAim) depth -= value;
                }
                when else {
                    system.debug('Critical error, wrong values found in map:'); 
                    system.debug('direction = ' + direction + ' & value = ' + value);
                    return null;
                }
            }
        }
        return depth*horizontal;
    }
    
    
    public static void exercise03_raw_part1(){
        List<String> exerciseList = getExerciseList_exercise03();
        String gammaValue = '';
        String epsilonValue = '';
        //length is constant (12)
        for(Integer i = 0; i < exerciseList[0].length(); i++){
            Integer gammaRate = 0;
            for(String value : exerciseList){
                List<String> sepnum = value.split('');
                gammaRate += Integer.valueOf(sepnum[i]);
            }
            if(gammaRate >= (exerciseList.size()/2) ){
                gammaValue += '1';
                epsilonValue += '0';
            } else {
                gammaValue += '0';
                epsilonValue += '1';
            }
        }
        Integer gamma = transformBinaryToInteger(gammaValue);
        Integer epsilon = transformBinaryToInteger(epsilonValue);
		System.debug(gammaValue + '   &   ' + epsilonValue);
        System.debug(gamma + '  *  ' + epsilon + '   =  ' + (gamma * epsilon));
    } 
    
    public static void exercise03_raw_part2(){
        List<String> typeO2GenList = exercise03_raw_part2_executor('O2Gen');
        List<String> typeCO2ScrubList = exercise03_raw_part2_executor('CO2Scrub');
        
        if(typeO2GenList.size() == 1 && typeCO2ScrubList.size() == 1){
            Integer O2Gen = transformBinaryToInteger(typeO2GenList[0]);
            Integer CO2Scrub = transformBinaryToInteger(typeCO2ScrubList[0]);
            System.debug('O2Gen (' + O2Gen + ')  *  CO2Scrub (' + CO2Scrub + ')  =  ' + (O2Gen * CO2Scrub) );
        }
        
    }
    
    public static List<String> exercise03_raw_part2_executor(String type){
        if(type != 'O2Gen' && type != 'CO2Scrub') return null;
        
        List<String> exerciseList = getExerciseList_exercise03();
        //binary length is constant (12)
        //O2Gen: most common bit criteria
        //CO2Scrub: least common bit criteria
        String bitsToKeep = null;
        
        List<String> exerciseList_modified = exerciseList;
        for(Integer i = 0; i < 12; i++){
            List<String> updateList = new List<String>();
            Integer occurenceOne = 0;
            Integer occurenceZero = 0;
            for(String value : exerciseList_modified){
                List<String> sepNum = value.split('');
                if(sepnum[i] == '0'){
                    occurenceZero++;
                } else {
                    occurenceOne++;
                }
            }
            if((type == 'O2Gen' && occurenceOne >= occurenceZero) || (type == 'CO2Scrub' && occurenceOne < occurenceZero)){
                bitsToKeep = '1';
            } else {
            	bitsTokeep = '0';
            }
            for(String value : exerciseList_modified){
                List<String> sepNum = value.split('');
                if(sepnum[i] == bitsToKeep){
                    updateList.add(value);
                }
            }
            if(!updateList.isEmpty()){
                exerciseList_modified = updateList;
            }
        }
        return exerciseList_modified;
    } 
    
    public static Integer transformBinaryToInteger(String binaryValue){
        Integer finalInt = 0;
        List<String> binList = binaryValue.split('');
        for(Integer i = 0; i < binaryValue.length(); i++){
            Integer numFromRight = binaryValue.length() - (i + 1); //binary position, rightmost number is zero
            finalInt += (Integer) (Integer.valueOf(binList[i]) * math.pow(Double.valueOf(2), Double.valueOf(numFromRight)));
        }
        return finalInt;
    }
    
    
    private static List<Integer> getExerciseList_exercise01(){
        List<Integer> exerciseList = new List<Integer>{
            143,147,150,166,180,187,188,185,199,198,199,197,218,221,238,239,233,234,
                217,212,215,216,215,217,220,241,245,232,230,234,206,251,272,273,278,279,
                285,292,288,286,289,290,294,301,298,300,297,305,306,310,340,343,352,356,
                362,376,380,383,382,385,372,391,384,385,398,430,426,422,423,433,419,421,
                431,424,442,450,453,449,487,491,462,464,466,467,468,466,482,484,501,500,
                501,497,498,497,508,516,521,540,541,536,537,536,542,549,535,541,548,549,
                551,570,572,606,605,601,608,609,611,605,631,618,635,636,635,636,637,638,
                676,673,668,674,683,684,683,680,687,688,698,700,706,696,713,707,708,719,
                721,728,719,723,715,712,722,721,709,680,681,680,681,690,686,687,682,683,
                680,693,708,718,730,743,726,753,747,748,751,772,801,805,797,789,790,797,
                812,806,813,815,813,815,822,835,843,854,858,859,860,869,872,870,864,876,
                880,882,865,869,876,882,886,885,898,900,909,913,902,910,914,916,920,898,
                899,931,936,937,938,941,950,939,942,935,932,941,945,944,957,959,967,975,
                990,1011,1008,1011,1015,1017,1018,1011,1010,1035,1036,1040,1041,1046,1048,
                1027,1047,1069,1079,1074,1075,1080,1079,1083,1071,1077,1080,1081,1082,1083,
                1085,1087,1089,1095,1096,1099,1110,1112,1119,1122,1124,1130,1133,1143,1139,
                1141,1142,1144,1176,1175,1159,1165,1172,1182,1203,1209,1193,1194,1193,1191,
                1196,1201,1202,1205,1216,1219,1220,1213,1212,1220,1226,1233,1234,1236,1239,
                1240,1242,1237,1261,1259,1257,1245,1251,1252,1272,1276,1277,1279,1284,1285,
                1286,1285,1315,1316,1331,1333,1335,1347,1344,1343,1342,1340,1354,1359,1367,
                1368,1378,1380,1358,1370,1371,1387,1388,1402,1404,1406,1401,1403,1405,1407,
                1408,1428,1432,1433,1434,1435,1446,1460,1461,1460,1468,1471,1472,1474,1465,
                1473,1496,1507,1510,1506,1502,1509,1512,1515,1516,1524,1526,1527,1528,1527,
                1541,1544,1545,1543,1548,1551,1544,1545,1550,1554,1556,1557,1558,1575,1578,
                1581,1587,1586,1590,1584,1571,1576,1574,1575,1585,1601,1604,1612,1613,1600,
                1587,1591,1596,1595,1601,1608,1614,1615,1614,1634,1636,1637,1639,1642,1629,
                1617,1618,1617,1612,1613,1614,1615,1617,1608,1609,1611,1608,1634,1636,1641,
                1637,1657,1665,1668,1679,1680,1695,1697,1698,1669,1670,1669,1673,1672,1678,
                1670,1671,1673,1689,1683,1685,1691,1692,1669,1670,1679,1672,1684,1704,1700,
                1692,1714,1715,1716,1712,1714,1716,1714,1718,1719,1713,1717,1710,1711,1721,
                1745,1752,1767,1762,1787,1785,1786,1790,1796,1814,1843,1859,1871,1876,1890,
                1891,1892,1894,1912,1914,1939,1955,1956,1960,1964,1967,1970,1971,1972,1969,
                1970,1984,1996,2017,2018,2020,2005,2006,2005,2007,2005,2006,2027,2031,2032,
                2012,2014,2013,2016,2014,2018,2040,2042,2061,2064,2063,2080,2086,2094,2063,
                2071,2092,2077,2078,2079,2080,2099,2100,2103,2118,2119,2124,2128,2135,2136,
                2135,2136,2137,2135,2163,2168,2162,2164,2160,2161,2162,2165,2169,2168,2185,
                2191,2197,2212,2224,2228,2229,2230,2243,2250,2251,2252,2255,2256,2247,2253,
                2262,2296,2317,2324,2327,2299,2300,2290,2291,2303,2292,2293,2294,2297,2298,
                2308,2309,2312,2337,2340,2349,2354,2345,2341,2340,2341,2344,2345,2341,2346,
                2352,2357,2340,2339,2336,2339,2351,2356,2358,2364,2366,2367,2370,2376,2377,
                2375,2378,2391,2394,2389,2391,2388,2389,2407,2420,2417,2416,2424,2443,2455,
                2457,2446,2449,2458,2466,2479,2486,2478,2491,2503,2507,2513,2518,2500,2502,
                2504,2514,2516,2517,2518,2529,2532,2543,2544,2543,2545,2553,2548,2559,2563,
                2573,2587,2584,2581,2579,2582,2577,2588,2589,2614,2617,2620,2622,2615,2619,
                2618,2610,2616,2615,2618,2616,2627,2630,2641,2659,2662,2663,2661,2669,2662,
                2687,2690,2691,2693,2696,2728,2746,2743,2746,2745,2746,2742,2749,2756,2750,
                2738,2743,2744,2746,2750,2753,2762,2770,2767,2766,2778,2780,2781,2776,2763,
                2762,2763,2766,2762,2753,2761,2768,2772,2746,2762,2767,2774,2795,2806,2809,
                2816,2830,2821,2837,2836,2838,2842,2831,2815,2816,2818,2817,2822,2817,2823,
                2834,2825,2818,2821,2847,2846,2845,2847,2848,2849,2863,2872,2866,2874,2875,
                2885,2886,2892,2898,2897,2917,2922,2916,2921,2922,2921,2940,2945,2935,2950,
                2946,2949,2951,2948,2940,2941,2940,2939,2955,2943,2941,2942,2945,2961,2962,
                2965,2975,2970,2971,2960,2961,2956,2960,2961,2967,2966,2979,2976,2983,3012,
                3024,3021,3041,3040,3041,3042,3048,3077,3088,3091,3109,3107,3116,3111,3115,
                3121,3095,3097,3077,3059,3065,3068,3061,3062,3061,3063,3068,3070,3073,3057,
                3075,3082,3089,3086,3090,3092,3106,3112,3118,3120,3119,3121,3119,3126,3133,
                3135,3163,3166,3167,3181,3185,3191,3197,3198,3199,3194,3210,3216,3224,3225,
                3235,3237,3245,3253,3259,3248,3256,3273,3265,3248,3249,3258,3257,3256,3255,
                3250,3252,3260,3261,3267,3268,3269,3284,3294,3334,3337,3340,3307,3316,3320,
                3328,3330,3350,3357,3363,3364,3361,3396,3397,3410,3411,3433,3452,3453,3465,
                3467,3469,3470,3467,3480,3494,3517,3519,3527,3542,3546,3547,3544,3570,3571,
                3596,3604,3603,3587,3588,3591,3589,3590,3591,3600,3598,3599,3600,3599,3600,
                3609,3608,3610,3611,3632,3633,3632,3633,3635,3642,3643,3656,3652,3653,3657,
                3676,3677,3687,3690,3693,3694,3697,3702,3703,3722,3729,3730,3731,3737,3744,
                3747,3751,3757,3758,3761,3769,3781,3796,3798,3797,3798,3812,3848,3849,3850,
                3854,3861,3859,3863,3867,3870,3882,3884,3876,3879,3909,3908,3910,3909,3908,
                3886,3888,3889,3891,3920,3921,3922,3913,3955,3956,3974,3975,3976,3988,3992,
                3999,4009,4010,4019,4023,4024,4035,4045,4044,4046,4072,4074,4093,4101,4105,
                4111,4141,4146,4147,4160,4162,4161,4162,4156,4158,4160,4168,4169,4168,4169,
                4192,4191,4222,4239,4227,4228,4226,4228,4227,4228,4221,4222,4223,4248,4249,
                4258,4249,4257,4260,4258,4257,4259,4260,4267,4284,4285,4286,4283,4280,4281,
                4280,4279,4282,4289,4290,4295,4300,4289,4290,4291,4300,4310,4314,4319,4320,
                4321,4324,4330,4326,4340,4326,4327,4332,4333,4334,4339,4361,4369,4370,4374,
                4372,4382,4398,4399,4395,4396,4397,4400,4404,4401,4405,4415,4427,4433,4446,
                4447,4455,4456,4457,4458,4467,4471,4463,4470,4460,4458,4459,4457,4468,4470,
                4448,4449,4453,4474,4470,4475,4474,4473,4472,4474,4476,4478,4479,4483,4484,
                4485,4481,4483,4492,4505,4513,4529,4530,4531,4503,4504,4505,4499,4500,4516,
                4517,4513,4497,4493,4494,4524,4537,4543,4544,4551,4552,4555,4565,4567,4566,
                4567,4566,4590,4591,4596,4597,4588,4572,4575,4572,4574,4575,4576,4584,4572,
                4578,4579,4593,4600,4604,4584,4586,4583,4599,4601,4603,4625,4624,4625,4627,
                4623,4624,4620,4618,4617,4616,4617,4612,4623,4634,4635,4623,4628,4629,4631,
                4633,4654,4659,4669,4674,4677,4678,4694,4699,4701,4713,4714,4722,4724,4725,
                4761,4785,4791,4783,4790,4791,4792,4809,4835,4840,4845,4852,4851,4852,4846,
                4848,4849,4854,4856,4862,4856,4875,4876,4878,4892,4893,4903,4891,4909,4923,
                4938,4939,4944,4953,4954,4975,4977,4978,4984,4987,4989,4987,4995,4994,4996,
                5000,5008,5018,5024,5027,5028,5031,5035,5051,5059,5061,5065,5069,5090,5110,
                5111,5113,5115,5129,5128,5139,5140,5141,5142,5149,5148,5147,5153,5157,5178,
                5189,5209,5217,5211,5215,5221,5243,5244,5275,5287,5290,5300,5301,5297,5300,
                5289,5311,5314,5303,5304,5306,5307,5316,5329,5330,5333,5334,5335,5343,5359,
                5380,5382,5383,5392,5403,5409,5410,5420,5427,5438,5448,5455,5458,5489,5490,
                5491,5492,5494,5497,5522,5523,5525,5536,5537,5542,5522,5529,5534,5535,5545,
                5546,5544,5538,5547,5551,5550,5551,5552,5553,5565,5578,5589,5590,5589,5592,
                5601,5614,5615,5614,5615,5616,5626,5627,5629,5647,5649,5650,5645,5646,5647,
                5672,5690,5692,5697,5701,5697,5702,5705,5718,5720,5725,5747,5749,5751,5756,
                5762,5764,5771,5772,5771,5772,5809,5822,5823,5840,5841,5839,5838,5839,5840,
                5838,5852,5853,5859,5865,5879,5885,5899,5907,5910,5936,5943,5957,5953,5958,
                5968,5979,5971,5966,5967,5971,5991,5993,5994,5993,5996,5993,6004,6010,6017,
                6018,6017,6038,6036,6035,6036,6039,6042,6037,6059,6062,6067,6068,6084,6077,
                6080,6081,6079,6093,6095,6098,6111,6107,6114,6105,6104,6111,6112,6120,6126,
                6140,6143,6142,6148,6152,6159,6150,6152,6168,6169,6167,6161,6160,6159,6160,
                6168,6169,6188,6200,6220,6221,6219,6221,6220,6232,6233,6234,6242,6247,6246,
                6247,6253,6258,6256,6249,6228,6225,6223,6227,6228,6259,6265,6268,6270,6271,
                6275,6270,6263,6265,6279,6323,6365,6374,6397,6415,6416,6419,6403,6405,6410,
                6417,6424,6425,6422,6432,6442,6451,6459,6458,6463,6485,6486,6509,6508,6532,
                6535,6551,6562,6563,6572,6571,6590,6628,6629,6627,6625,6620,6619,6625,6616,
                6615,6646,6648,6649,6651,6653,6645,6651,6652,6665,6660,6664,6665,6684,6685,
                6694,6695,6696,6693,6694,6703,6702,6696,6693,6694,6691,6725,6728,6715,6722,
                6728,6729,6730,6742,6753,6754,6752,6753,6761,6771,6773,6778,6779,6795,6819,
                6797,6799,6798,6807,6809,6837,6861,6864,6865,6868,6869,6867,6861,6871,6874,
                6872,6873,6875,6867,6877,6876,6898,6900,6902,6904,6905,6915,6908,6927,6928,
                6935,6942,6943,6945,6948,6943,6947,6990,6993,7013,7014,6997,6976,6972,6975,
                6976,6982,6991,7006,7009,7015,7019,7018,7008,7011,7018,7023,7027,7044,7054,
                7060,7058,7057,7061,7038,7036,7040,7041,7039,7042,7039,7037,7049,7056,7057,
                7072,7095,7101,7102,7104,7103,7106,7107,7108,7112,7117,7119,7117,7132,7130,
                7137,7143,7135,7138,7152,7156,7180,7181,7182,7179,7180,7174,7172,7162,7177,
                7180,7187,7153,7159,7145,7139,7140,7137,7156,7160,7161,7162,7163,7170,7163,
                7171,7167,7166,7167,7169,7170,7178,7179,7166,7177,7176,7203,7194,7187,7191,
                7202,7198,7199,7205,7206,7207,7208,7214,7215,7214,7215,7217,7208,7205,7214,
                7215,7216,7212,7214,7222,7226,7231,7229,7239,7238,7239,7250,7252,7255,7277,
                7279,7284,7290,7293,7294,7316,7325,7326,7327,7328,7326,7325,7329,7335,7340,
                7344,7337,7338,7348,7366,7376,7377,7382,7387,7401,7392,7396,7400,7406,7405,
                7410,7425,7426,7432,7449,7450,7444,7450,7455,7456,7471,7472,7494,7514,7515,
                7512,7515,7517,7514,7538,7539,7540,7556,7557,7553,7549,7546,7566,7567,7564,
                7565,7559,7560,7563,7571,7570,7572,7580,7587,7595,7597,7614,7622,7621,7627,
                7656,7652,7659,7658,7657,7660,7665,7664,7666,7669,7678,7680,7682,7683,7669,
                7692,7695,7699,7705,7717,7720,7730,7733,7748,7759,7747,7748,7759,7778,7777,
                7778,7780,7781,7780,7788,7787,7788,7814,7810,7787,7788,7802,7803,7813,7815,
                7818,7823,7830,7852,7868,7874,7879,7873,7854,7871,7877,7876,7883,7885,7887,
                7886,7889,7893,7900,7909,7910,7906,7910,7913,7918,7919,7941,7947,7948,7949,
                7951,7952,7977,7976,7979,8010,8011,8014,8015,8031,8054,8056,8059,8085,8087,
                8107,8109,8115,8116,8117,8115,8116,8119,8127,8145,8147
                };
                    
                    return exerciseList;
    }
    
    private static List<String> getExerciseList_exercise02_raw(){
        List<String> exerciseList = new List<String>{
            'forward 3','down 7','forward 7','down 4','down 9','down 7','forward 5','forward 9','forward 3','forward 8','down 4',
                'down 6','down 3','forward 7','forward 1','forward 4','down 1','forward 7','forward 9','down 3','down 1','down 5',
                'forward 8','down 2','down 9','forward 3','down 9','down 7','down 6','down 1','forward 4','forward 9','forward 8',
                'down 3','down 9','down 5','forward 5','down 7','down 7','up 1','down 2','up 1','down 7','up 1','up 1','down 8','down 8',
                'forward 2','down 5','forward 9','forward 8','forward 4','up 2','down 9','down 7','forward 4','up 7','up 4','down 4',
                'down 3','forward 8','down 8','up 2','up 1','forward 3','up 6','up 8','down 5','down 4','down 4','forward 1','down 8',
                'forward 3','forward 5','forward 4','forward 2','forward 7','up 5','up 2','forward 2','forward 5','down 4','up 6',
                'forward 3','forward 1','forward 1','forward 6','forward 7','forward 1','forward 8','forward 4','forward 4','forward 8',
                'down 6','down 8','forward 4','forward 1','down 8','forward 3','forward 3','forward 9','forward 9','forward 3','up 1',
                'down 2','down 5','forward 4','forward 5','forward 7','forward 4','forward 4','up 5','forward 1','down 9','down 9',
                'down 1','up 7','down 8','up 6','down 4','forward 7','down 8','down 1','forward 4','forward 5','forward 9','down 2',
                'forward 7','forward 7','up 2','up 1','forward 9','forward 1','forward 7','up 3','forward 8','forward 1','down 6',
                'down 6','down 4','forward 2','forward 1','down 3','down 4','down 2','forward 9','up 8','down 4','down 3','down 1',
                'down 1','forward 6','forward 6','down 7','forward 1','forward 5','forward 9','forward 5','forward 1','up 8','forward 7',
                'up 3','forward 6','down 5','up 8','down 4','down 8','forward 2','up 7','forward 9','down 9','forward 1','down 5',
                'forward 8','down 7','forward 8','forward 1','forward 5','down 4','down 1','forward 4','up 6','down 3','down 1',
                'forward 1','forward 1','up 8','down 9','forward 8','forward 5','down 5','forward 1','up 9','down 6','down 4','up 2',
                'forward 5','down 7','up 1','forward 3','up 5','forward 9','up 6','down 4','forward 6','down 8','down 2','forward 3',
                'forward 4','down 5','down 7','down 4','up 3','up 8','down 8','up 8','down 8','forward 8','down 3','up 3','forward 8',
                'down 6','forward 2','down 8','down 5','up 2','forward 1','forward 4','down 1','forward 5','forward 5','forward 2',
                'forward 2','forward 4','down 7','forward 6','up 6','down 8','forward 4','forward 6','forward 2','down 8','down 2',
                'up 1','down 8','forward 9','up 5','forward 8','up 9','down 1','down 2','forward 6','down 9','forward 3','up 8',
                'up 4','down 8','forward 2','down 1','forward 6','forward 4','down 4','forward 4','up 8','down 6','forward 3','up 2',
                'up 6','down 1','down 3','down 1','up 6','down 9','up 6','forward 9','down 4','forward 3','forward 1','up 7','down 1',
                'forward 5','up 1','up 8','forward 5','down 5','forward 2','up 8','up 7','forward 4','up 7','up 4','forward 5',
                'forward 3','down 9','forward 1','down 8','forward 3','up 3','down 7','forward 4','down 7','down 5','down 8','down 8',
                'forward 6','forward 5','up 4','down 6','forward 4','up 2','up 4','down 4','down 9','forward 7','down 8','forward 6',
                'forward 5','up 8','down 6','forward 1','up 2','forward 5','forward 7','down 4','down 6','forward 9','forward 2','up 6',
                'up 6','forward 1','up 6','forward 8','down 7','forward 1','down 1','up 9','up 1','forward 1','forward 7','forward 5',
                'down 4','forward 6','forward 4','down 8','up 6','up 8','forward 6','forward 3','up 6','forward 6','down 8','down 5',
                'down 5','down 2','down 6','forward 1','forward 4','forward 5','down 5','forward 6','forward 2','forward 2','up 7',
                'up 6','up 7','forward 7','forward 6','down 7','down 7','up 4','forward 5','forward 2','down 6','up 4','forward 8',
                'down 1','down 5','up 6','down 4','down 3','down 8','forward 8','down 9','forward 8','forward 6','down 4','down 3',
                'forward 6','up 4','up 9','forward 3','down 3','down 9','forward 1','down 7','forward 2','up 7','down 6','forward 5',
                'down 8','down 1','forward 8','down 4','up 3','down 5','forward 6','down 7','forward 3','forward 6','forward 8',
                'forward 6','down 4','down 6','forward 9','up 8','forward 2','forward 8','forward 1','forward 1','forward 3',
                'forward 8','forward 6','forward 8','down 5','down 2','down 6','up 4','forward 5','forward 9','forward 1','down 3',
                'down 6','down 7','forward 5','forward 8','up 1','forward 4','up 3','forward 6','down 3','down 7','down 1','down 1',
                'forward 8','forward 3','forward 2','forward 1','forward 3','forward 7','up 6','down 8','forward 3','forward 8',
                'forward 1','forward 4','up 3','down 7','up 9','up 6','forward 1','forward 6','forward 5','down 5','down 2','forward 8',
                'up 8','down 4','forward 6','down 2','forward 1','down 8','forward 2','forward 9','forward 1','down 9','down 1','down 9',
                'down 1','up 9','forward 3','forward 7','forward 3','down 5','up 3','forward 4','up 1','forward 2','down 8','forward 8',
                'down 1','up 9','down 7','forward 9','up 6','down 3','forward 9','down 2','down 3','up 5','up 5','forward 8','down 2',
                'forward 2','up 3','down 8','down 1','down 9','forward 5','down 5','down 5','down 4','down 8','forward 7','up 3','up 4',
                'up 4','up 7','down 2','down 6','up 3','down 9','up 2','forward 6','forward 1','down 7','down 5','forward 6','down 6',
                'up 4','down 4','down 8','up 5','forward 9','down 8','forward 1','forward 2','forward 8','forward 2','forward 3','up 9',
                'up 8','up 9','up 6','down 5','forward 7','up 8','forward 1','down 3','down 8','forward 3','up 6','down 2','forward 2',
                'up 4','up 4','forward 6','forward 1','forward 4','down 3','down 1','up 7','down 9','up 1','down 9','down 4','up 2',
                'forward 8','down 3','forward 7','up 6','forward 7','up 2','forward 5','down 3','up 2','down 3','down 8','forward 5',
                'down 8','forward 7','up 6','down 4','forward 4','down 1','up 3','forward 6','down 1','down 2','down 2','forward 7',
                'down 6','down 2','forward 9','down 2','forward 2','down 2','forward 6','down 9','up 4','up 7','up 6','down 3',
                'forward 3','down 7','down 6','forward 8','down 4','up 3','down 1','forward 8','down 4','forward 5','forward 1',
                'down 7','forward 5','up 3','down 7','forward 3','down 4','up 1','down 5','forward 8','down 2','forward 9','forward 3',
                'up 2','down 9','forward 5','up 7','down 7','down 1','down 7','down 8','forward 1','down 9','down 7','forward 4',
                'down 5','forward 9','down 6','down 1','forward 2','up 4','up 3','down 1','forward 4','up 3','forward 4','up 2',
                'forward 6','down 6','up 8','down 3','forward 5','down 2','forward 9','down 3','down 7','forward 4','down 5','up 9',
                'up 9','down 4','up 5','forward 1','down 8','up 8','up 4','up 2','up 8','forward 5','down 5','up 1','down 6','down 3',
                'up 4','forward 3','forward 1','forward 1','up 4','forward 1','down 6','forward 7','forward 4','forward 4','forward 9',
                'forward 6','down 6','forward 4','up 7','down 5','down 2','forward 3','down 7','forward 8','down 7','forward 4','up 9',
                'down 1','forward 3','forward 1','forward 4','down 2','up 2','down 1','down 4','down 7','forward 5','forward 3','up 5',
                'forward 1','down 4','down 8','up 4','up 1','down 1','down 4','down 2','down 4','up 8','down 3','forward 8','up 5',
                'down 4','forward 9','forward 7','down 4','forward 7','forward 9','forward 6','forward 9','up 9','down 3','up 4',
                'down 8','forward 9','up 2','up 3','forward 8','forward 3','forward 1','forward 7','forward 8','forward 9','down 7',
                'forward 3','forward 3','forward 4','up 8','forward 1','forward 5','up 9','down 2','down 7','forward 5','up 4',
                'forward 9','down 9','up 2','forward 7','down 9','up 8','up 1','up 1','up 5','forward 4','down 2','forward 7','down 1',
                'down 8','down 8','forward 3','forward 8','up 9','forward 7','forward 6','forward 3','forward 7','up 3','up 6',
                'forward 5','forward 5','down 2','down 7','down 7','up 7','forward 6','forward 1','forward 7','up 6','down 9',
                'forward 7','forward 1','up 7','forward 4','forward 9','up 2','down 5','down 6','down 4','forward 1','forward 7',
                'forward 4','forward 5','down 2','forward 5','down 9','forward 7','forward 4','up 5','down 6','forward 2',
                'forward 4','forward 8','up 1','down 2','up 9','forward 6','down 1','forward 6','forward 4','down 6','forward 6',
                'up 4','down 5','forward 8','down 3','up 4','forward 3','down 6','up 7','down 8','down 5','down 7','forward 4',
                'down 1','forward 5','up 9','up 3','down 4','forward 9','forward 6','forward 1','up 5','down 5','forward 1',
                'forward 6','down 4','up 7','forward 5','down 5','forward 1','forward 5','down 4','forward 6','down 6','down 5',
                'down 5','forward 4','down 5','forward 2','down 9','down 6','down 5','forward 5','down 9','down 7','up 8',
                'down 3','forward 6','down 4','forward 8','forward 9','down 1','up 3','forward 4','up 3','forward 7','down 5',
                'up 8','forward 1','up 1','down 2','forward 1','up 9','down 4','forward 1','up 3','down 9','up 8','down 2',
                'up 4','forward 2','forward 8','up 8','forward 9','forward 2','down 4','forward 8','down 4','forward 9','down 1',
                'up 8','forward 6','down 4','down 8','forward 1','forward 1','forward 5','forward 9','up 4','down 7','forward 4',
                'down 5','forward 1','down 4','up 8','up 4','forward 2','forward 9','down 8','down 3','down 2','up 3','down 1',
                'down 8','forward 5','down 6','down 5','forward 8','down 8','down 1','forward 1','forward 3','forward 7','forward 1',
                'up 2','up 3','forward 9','down 2','forward 5','down 8','forward 7','forward 3','up 5','forward 1','forward 1','up 8',
                'down 1','down 2','down 7','down 1','down 9','forward 7','down 8','down 4','up 8','forward 1','down 6','forward 9',
                'forward 7','up 2','forward 3','forward 2','up 3','up 6','up 1','down 1','up 9','forward 8','forward 6','down 6',
                'up 8','down 8','forward 5','forward 7','down 7','forward 3','forward 9','down 8','down 8','forward 2','up 7',
                'down 4','down 7','up 6','down 3','forward 1','forward 8','down 5','down 6','up 5','forward 8','forward 6','up 8',
                'forward 8','up 3','up 6','up 3','forward 1'
                };
                    return exerciseList;
    }
    
    private static Map<String, List<Integer>> getExerciseMap_exercise02(){
        List<String> exList = getExerciseList_exercise02_raw();
        List<Integer> forwardList = new List<Integer>();
        List<Integer> downList = new List<Integer>();
        List<Integer> upList = new List<Integer>();
        Map<String, List<Integer>> exerciseMap = new Map<String, List<Integer>>();
        for(Integer i = 0; i < exList.size(); i++){
            List<String> temp = exList[i].split(' ');
            if(!temp.isEmpty() && temp.size() == 2){
                switch on temp[0] {
                    when 'forward'{
                        forwardList.Add(Integer.valueOf(temp[1]));
                    }
                    when 'down'{
                        downList.Add(Integer.valueOf(temp[1]));
                    }
                    when 'up' {
                        upList.Add(Integer.valueOf(temp[1]));
                    }
                    when else {
                        system.debug('Critical error, wrong values found in map:'); 
                        system.debug('iteration = ' + i + ' & direction = ' + temp[0] + ' & value = ' + temp [1]);
                        return null;
                    }
                }
            } else {
                system.debug('error on split on iteration: ' + i);
                return null;
            }
        }
        if(!forwardList.isEmpty()) exerciseMap.put('forward', forwardList);
        if(!upList.isEmpty()) exerciseMap.put('up', upList);
        if(!downList.isEmpty()) exerciseMap.put('down', downList);
        return exerciseMap;
    }
    
    private static List<String> getExerciseList_exercise03(){
        List<String> exerciseList = new List<String>{
            	'000011110010', '010000100100', '010011111111', '000101001111', '010100011111', '111100111011', '100111011010', '111001000001', 
                '100000100110', '100110011000', '010101010111', '001100100001', '111100111111', '111010001000', '101011101110', '111101001000', 
                '000000111101', '001010111011', '111101100010', '110001100111', '110011011011', '010000000110', '010111100111', '111001111000', 
                '110001101111', '100010011011', '100100110001', '000001100111', '110001110000', '010011011010', '010111110010', '111100101111', 
                '000110111101', '101101101001', '111110000100', '001110100100', '000000110011', '000001010000', '010110000011', '000101010100', 
                '110010010100', '001110011011', '001011110011', '001011000100', '111011100101', '001000011101', '011110001010', '100110100111', 
                '100100101100', '000101101011', '001100000110', '010101000010', '000111001011', '100001110100', '110000110110', '101001110011', 
                '010001111001', '111110111000', '000110011010', '101110000001', '110000100001', '111001000011', '000000101001', '000001100101', 
                '001101110111', '001100000001', '100111100100', '000111000001', '000100111011', '000000110100', '111100100100', '001001000000', 
                '111001100111', '100101110010', '011000110101', '110100110111', '001001110101', '110010011100', '011001011111', '001010110111', 
                '110101000111', '010010011001', '100010110001', '101110101011', '010010011000', '111001000110', '001001100001', '000001110111', 
                '011100011011', '101101011001', '111000011111', '101001110101', '100100110000', '101000001111', '011001110100', '001000100101', 
                '011100111011', '001100101110', '111000111111', '000001100100', '101010010001', '101100110001', '110011001100', '111000100111', 
                '000011000111', '010001000011', '010111100000', '111001000101', '011000001011', '001111100110', '101111110011', '110011000001', 
                '011011011100', '011101000011', '001111100100', '110010110010', '110100110110', '110000001000', '110010001000', '101111101010', 
                '010000001100', '110010010011', '110000011000', '101100011110', '001010010000', '011010011101', '101110100100', '100010011010', 
                '011010011000', '101110000111', '001010100110', '100000000101', '101100100101', '101001111010', '011110010111', '101000111000', 
                '111111010110', '000001111000', '101010111110', '001101100011', '001010111100', '001001100111', '111010100001', '100101101100', 
                '111101110110', '011010111000', '110100000001', '110101000110', '100000010000', '111010100011', '111110001100', '000001101100', 
                '000011011000', '011101000000', '111011111010', '110011100001', '100000111101', '000101010101', '000001110100', '010010000100', 
                '010110110001', '101000100110', '111110010000', '010100111100', '101101000100', '011100001111', '111000001111', '111011111100', 
                '111011001011', '101000010110', '100000011111', '000100010111', '100010111111', '010111000111', '010100111001', '000000000001', 
                '110011111000', '001010001010', '111100011110', '011001001011', '011101101110', '100100110111', '011010010101', '100001111100', 
                '010010111001', '101100000100', '100001000110', '110101101000', '001010000100', '011100111100', '001110010100', '001100001100', 
                '110100100011', '000111010101', '100010011111', '010110110111', '100111010000', '001101111100', '000110011110', '000100101010', 
                '101011001010', '101111010101', '000001000011', '111001000010', '100011100010', '101000000111', '111000010111', '111001110110', 
                '110000100110', '111010011001', '010101110101', '000111010000', '011110100110', '100100010111', '000110001100', '001110111110', 
                '010001001111', '011011110111', '110000111011', '101010110001', '101101010011', '100110101001', '100010010101', '000011111111', 
                '010110110110', '000100110111', '110101011101', '111001100001', '001100110100', '011001010101', '100010101110', '110001011110', 
                '000100101011', '101110100010', '001101000000', '110111110101', '110100010110', '100111000000', '100001000101', '001100111011', 
                '000010001001', '001101001010', '101010001101', '110101101111', '001101011001', '110001000001', '001110100000', '001010010011', 
                '100000010010', '111001101011', '101011000111', '001000010011', '010111111101', '101111000111', '010100100101', '000100000110', 
                '000010110011', '000111011110', '100011110111', '101010110011', '011111001110', '111011110100', '010011000001', '000011101110', 
                '000101010011', '100011110101', '001101001111', '011000010001', '011010010000', '001101011110', '110010010001', '110111111100', 
                '010111001100', '000000111000', '101100110100', '110001111000', '010101110110', '111000101001', '110110010011', '100000101010', 
                '111101100011', '000110100110', '000110100111', '001111111101', '001101110010', '101101100010', '001110001011', '101101001111', 
                '000110100101', '110010011101', '001100011100', '111010101001', '001111001001', '010001100101', '110001101001', '010110011011', 
                '110111110110', '100110001110', '000011010100', '110000001011', '110101110100', '111110101100', '111100100110', '100000100101', 
                '011011010010', '011000000000', '001110001010', '001011110110', '111111010101', '101000011011', '110001110110', '001110010011', 
                '100111111010', '110110011110', '000011101010', '100010011000', '100100001111', '111110001101', '111011111001', '101010011100', 
                '001100000000', '100010000010', '000001110110', '010100110111', '100010100000', '101001101010', '100000011010', '100110111011', 
                '011100010111', '100110101101', '110011010101', '001011110101', '001110010000', '000010101010', '101110001011', '011000010011', 
                '101001011000', '010101101001', '000111110010', '101101111111', '010000011000', '110011101011', '001011101001', '111000001100', 
                '101110100110', '011100101001', '001101011011', '011110101001', '010111101011', '110010000100', '001101010000', '010011011100', 
                '100000110000', '111101100110', '111110110100', '011101111100', '110111110100', '110100010101', '011110110111', '011011011000', 
                '000000100101', '001001010011', '101100001101', '001010101011', '111100011101', '100101101110', '111000001010', '101010011010', 
                '010001111101', '110011001101', '011000111011', '000111101001', '100101100111', '110111111000', '110000000010', '101010111011', 
                '111001110010', '011100110101', '100010111001', '000110110101', '010110101110', '000001101111', '010110110010', '100000110001', 
                '010000001110', '111100110011', '011101101111', '100111000001', '110000000101', '100011010111', '110001001011', '101111001011', 
                '111110010011', '110111111101', '111111111101', '011111001010', '011011001101', '101111000100', '111000101111', '110010000000', 
                '010010111110', '110110110110', '000100001101', '001010001011', '001000010100', '110100001111', '000101000101', '111101101111', 
                '110011111111', '011010011011', '100101110111', '000110000111', '000100110100', '110110101010', '110001110100', '000001111111', 
                '011000000111', '111000100010', '101000010001', '011111000010', '001010001101', '110010100001', '100111101000', '011001101110', 
                '111100111001', '111101110011', '110101110010', '100100010100', '011001111111', '111001011110', '000010100111', '100010101000', 
                '011100111101', '110111011000', '010001111110', '011001001001', '010000011111', '011000001001', '101100000111', '111110000000', 
                '110100101111', '001000100011', '000011100010', '011100110001', '011010000100', '110110000001', '100001010101', '111111111011', 
                '000001010110', '010001110111', '100100111110', '111111011011', '101000111110', '001010011010', '101010011111', '111010000011', 
                '111011011111', '010100111000', '010010110111', '010010100101', '101100101100', '010110110100', '001111001101', '001101101001', 
                '110011010100', '100010100101', '001001010010', '000011000010', '111110000111', '001011010100', '100001000100', '001110001100', 
                '101001110010', '100010000100', '010001010001', '010100110001', '111101001011', '010111000110', '001110101011', '000101011100', 
                '010100101110', '101111111000', '011100111110', '010110111001', '101101001110', '001000011000', '001101100100', '010111011101', 
                '101101101111', '110100110100', '101110111100', '110111110001', '110000100101', '101111110010', '010101111100', '101000100111', 
                '001010101101', '100000010011', '010101010011', '000011101000', '011001000000', '101010110100', '100101101010', '100100011000', 
                '011100110011', '001010100001', '010000111000', '000101100111', '010001111111', '000011000110', '001011011010', '011101110011', 
                '101101010100', '000100000000', '111101100000', '001111110000', '001101111010', '010110100110', '111001001111', '001101110001', 
                '110110000010', '001101101000', '001100100101', '111101110100', '000101110001', '010010111011', '101000110100', '100110111001', 
                '111001010000', '000011001111', '101000011101', '100111111100', '010111100100', '101001101011', '101000101001', '001010001110', 
                '111001111101', '100011001011', '111101101011', '110111001100', '110100111010', '111101111010', '100111110011', '111100010000', 
                '101110000010', '001000111000', '011001110110', '011001101011', '110100110001', '010100110010', '101000111001', '010110010110', 
                '000010000000', '111100011100', '001110111111', '010010100110', '110001010010', '110101101010', '010011111000', '011101010110', 
                '100001101100', '000101100011', '111100011111', '010111111111', '110000101111', '101110111101', '110011000100', '010010000000', 
                '010100110100', '101011111101', '001011001110', '111000011100', '010110000100', '011110001000', '101010001110', '111001010111', 
                '000001101011', '001010011001', '110001000000', '110011100101', '101000011100', '001000101001', '100100100101', '101010000110', 
                '110001011111', '001000110100', '001000100111', '110010011001', '001001111011', '010101100100', '010110101101', '101101000110', 
                '010011111101', '000000111111', '100111111110', '100101111100', '110010000001', '010100010111', '011110110000', '111100110001', 
                '000010101101', '111111010011', '110110100000', '000000010100', '110000110100', '111101111111', '001001100100', '100000001110', 
                '011101001000', '010001101111', '100101110110', '101011101101', '111011110111', '101110011010', '000001101110', '000100011111', 
                '111111101010', '000101011101', '010110001001', '110001000110', '110101011110', '100110100011', '101100111000', '011011001110', 
                '111000110000', '000110001110', '100110011110', '110011101101', '101100011111', '011111000101', '011101000100', '000111110001', 
                '011111110011', '011001100101', '000100001100', '100100011101', '110011101110', '101000000110', '000100001111', '110010101000', 
                '010110000101', '110000010010', '111010111001', '001001000110', '001000011010', '110110001011', '001101001110', '111010011100', 
                '000101010110', '111111001000', '001001110000', '101011100111', '110101101001', '101111110110', '111010001011', '010100101100', 
                '010110110000', '110011010010', '101010111010', '010011001101', '011101000101', '101111111101', '110000000100', '011011011101', 
                '010101011000', '000011001101', '011101110000', '100111011101', '001100101001', '100101100000', '110010011010', '101111011001', 
                '110010111010', '110001100000', '100100010110', '100101010111', '100110111110', '010111011000', '100100101011', '101010011110', 
                '110011001011', '100011101110', '111000000110', '010011000100', '111011100011', '000000011100', '101011011000', '100110001011', 
                '001011101101', '000000000010', '010011001111', '001001110010', '111011100100', '100100010101', '111110000001', '011110100101', 
                '100110000100', '001011101110', '100010011110', '001000110000', '001100001010', '011001001110', '011010011001', '111110011010', 
                '001010011111', '100001100001', '101011110111', '111111001110', '010000000001', '001011110010', '111010011111', '101000110001', 
                '010011010100', '000111000011', '010101001110', '101000110111', '011010110001', '011010100001', '011010011110', '000101101101', 
                '101101100101', '011101101011', '000011001001', '111000111001', '111100111000', '000111100111', '111101111101', '000101011011', 
                '011111000100', '110101000001', '101000111011', '110011010001', '010011110101', '101000000010', '010111110101', '101101101000', 
                '110111010011', '000111111110', '100001110110', '100110001000', '110110000101', '111101100100', '010001101010', '111001000100', 
                '111001010100', '101110001000', '010000010110', '100001100110', '000110100010', '111101010010', '110000001111', '010001100111', 
                '001000001010', '110000011010', '001011100110', '100101101101', '011001011100', '001100101101', '011110111001', '001010001100', 
                '111011000011', '100100000111', '000100001010', '011100101100', '001101110100', '001100011110', '101010001111', '000011001011', 
                '111001010010', '110000101110', '000101000011', '010010000011', '110010101101', '010101011011', '101011110001', '110111100100', 
                '111010011010', '011101010101', '100001011100', '011011100010', '111000010100', '101011011001', '101110101100', '000010011011', 
                '111110101101', '100000101100', '010000101010', '010011111100', '110110100001', '100011001000', '000001000010', '101110010110', 
                '110101111000', '101001101000', '000001100000', '110010011110', '010111010110', '111101010101', '000010111011', '011110111000', 
                '010101111010', '001000000011', '110001101010', '111001011010', '111010110011', '100001010010', '001011101111', '000011101111', 
                '111011110010', '000011011001', '011110101100', '011001111101', '011010010111', '000100100101', '111100111100', '010000001001', 
                '110011110000', '010010010001', '000111101000', '100011001001', '100111001010', '011101111011', '100110011011', '101011111001', 
                '111111100011', '010010111000', '000001111001', '010110011001', '011100001011', '110001110111', '001010100111', '110110100010', 
                '010111000101', '100100001100', '011110101110', '111110111010', '000000010011', '110000101011', '111010100100', '011110011000', 
                '111010110001', '000010001110', '000001000111', '110010101111', '100001011111', '111001100100', '110000000110', '100011101100', 
                '101011001001', '000100101101', '101101101011', '001001110100', '100100111100', '010010101011', '011110100000', '110101100011', 
                '101101101010', '100101010110', '011000100000', '111000101000', '011110010110', '001000010111', '111010010111', '111100000111', 
                '011000100011', '010000111111', '011001010111', '011110011010', '111111011100', '011111101101', '101111011101', '101100100000', 
                '111111000000', '111111111111', '101011011101', '000010101100', '100101001101', '111111001010', '010100000000', '010111001011', 
                '101110010101', '000011011100', '110101011000', '111001101101', '000001011101', '000101011010', '100110000110', '111111001111', 
                '001011111110', '111010011110', '000011010110', '011010111110', '111110001001', '100011001110', '110111001101', '110100100101', 
                '101011100110', '110100000110', '010011100101', '001000010110', '101001100101', '111111110001', '100110111000', '111101001100', 
                '010001101000', '011100100101', '111101010011', '000110011001', '010100010100', '110100100010', '100101100100', '100011001101', 
                '001000100001', '110100100111', '111010011011', '011000010010', '111001100011', '001111101011', '010110111101', '000001011010', 
                '100000010110', '010100011011', '110000110011', '111111111010', '111000100100', '100100011011', '000111110110', '010000000010', 
                '010111110111', '100011100001', '001101000100', '011111011111', '000010011111', '000101011110', '001100100111', '101001000100', 
                '000011011010', '101101001101', '010010010110', '001100001110', '100101000001', '111100000101', '100000111111', '010111111011', 
                '101101110110', '001000010001', '110111101000', '110101001111', '101110000100', '110001110011', '010010011010', '011010101111', 
                '111110001010', '110010110000', '101001000110', '000010000001', '001100011111', '100101000110', '010101100011', '000100111100', 
                '101011010101', '010001110001', '001010011110', '101100001110', '101111010001', '000000010000', '011111001111', '100011101111', 
                '001000111100', '101001011111', '111111010111', '001010110110', '111101101110', '011000101011', '111011100110', '010001001000', 
                '001010111001', '111010111011', '111111110110', '110110001000', '001000100010', '101010101110', '101010100011', '100100111101', 
                '000110010001', '111110010110', '000101100001', '010100100111', '001101100010', '110011110111', '011100110110', '100101011000', 
                '011101011111', '110110000011', '100010110100', '011011001000', '111000101101', '110100000101', '011001000001', '001011000111'
        };
        return exerciseList;
    }
    
}