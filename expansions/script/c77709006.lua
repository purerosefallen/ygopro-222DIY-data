local m=77709006
local cm=_G["c"..m]
xpcall(function() require("expansions/script/lap") end,function() require("expansions/sekka1217/script/lap") end)
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.Sekka_name_with_lap=true
function cm.initial_effect(c)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return ep==tp
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
	    Duel.SetChainLimit(function(e,lp,tp)
            return lp==tp
        end)
    end)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,m)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)
end
function cm.thfilter1(c)
	return c:IsCode(m-6) and c:IsAbleToHand()
end
function cm.thfilter2(c)
	return Sekka.IsLap(c) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter1,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(cm.thfilter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(cm.thfilter1,tp,LOCATION_DECK,0,nil)
	local g2=Duel.GetMatchingGroup(cm.thfilter2,tp,LOCATION_DECK,0,nil)
	if #g1>0 and #g2>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g1:Select(tp,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg_=g2:Select(tp,1,1,nil)
		sg:Merge(sg_)
		Duel.ConfirmCards(1-tp,sg)
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
		local tg=sg:Select(1-tp,1,1,nil)
		local dg=sg-tg
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
		Duel.SendtoGrave(dg,REASON_EFFECT+REASON_DISCARD)
	end
end
