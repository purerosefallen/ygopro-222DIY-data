--序曲·十分钟的恋爱
local m=77707067
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
		local function f(c)
			return c:IsSetCard(0xb9c0) and c:IsAbleToGraveAsCost()
		end
		local mx=Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)
		if chk==0 then return mx>0 and Duel.IsExistingMatchingCard(f,tp,LOCATION_DECK,0,1,nil) end
		local g=Duel.GetMatchingGroup(f,tp,LOCATION_DECK,0,nil)
		local sg=Senya.SelectGroup(tp,HINTMSG_TOGRAVE,g,function(g)
			return g:GetClassCount(Card.GetCode)==#g
		end,nil,1,mx)
		e:SetLabel(#sg)
		Duel.SendtoGrave(sg,REASON_COST)
	end)
	e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>0 end
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local g=Duel.GetDecktopGroup(1-tp,e:GetLabel())
		for tc in aux.Next(g) do
			Duel.SendtoDeck(tc,tp,2,REASON_EFFECT)
			if tc:IsControler(tp) and tc:IsLocation(LOCATION_DECK) then
				tc:ReverseInDeck()
			end
		end
	end)
	c:RegisterEffect(e1)
end
