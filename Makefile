deploy_holiday_collectible_2023:
	forge script script/HolidayCollectible2023.s.sol:HolidayCollectible2023Deploy \
	--rpc-url $$SEPOLIA_RPC_URL --broadcast --verify -vvvv

deploy_holiday_collectible_2023_mainnet:
	forge script script/HolidayCollectible2023.s.sol:HolidayCollectible2023Deploy \
	--rpc-url $$MAINNET_RPC_URL --broadcast --verify -vvvv
