--Nanahira & Rin
local m=37564570
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
function cm.initial_effect(c)
	Senya.Nanahira(c)
	Senya.NegateEffectModule(c,1,m,Senya.SelfDiscardCost,aux.AND(Senya.NanahiraExistingCondition(false),function(e,tp,eg,ep,ev,re,r,rp)
		local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
		return (loc&LOCATION_ONFIELD)==0
	end),nil,LOCATION_HAND)
	Senya.NegateEffectModule(c,1,m-4000,aux.bfgcost,aux.AND(Senya.NanahiraExistingCondition(true),function(e,tp,eg,ep,ev,re,r,rp)
		local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
		return (loc&LOCATION_ONFIELD)~=0
	end),nil,LOCATION_GRAVE)
end
