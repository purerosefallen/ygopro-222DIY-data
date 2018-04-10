--秘谈·彷徨的旅程
local m=1111009
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c1110198") end,function() require("script/c1110198") end)
cm.named_with_Legend=true
--
function c1111009.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c1111009.con1)
	e1:SetTarget(c1111009.tg1)
	e1:SetOperation(c1111009.op1)
	c:RegisterEffect(e1)
--
end
--
function c1111009.cfilter1(c)
	return muxu.check_set_Urban(c) and c:IsFaceup()
end
function c1111009.con1(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.IsExistingMatchingCard(c1111009.cfilter1,tp,LOCATION_FZONE,LOCATION_FZONE,1,nil)
	local b2=Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD+LOCATION_HAND,0)-Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)
	return b1 or b2<1
end
--
function c1111009.tfilter1(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c1111009.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,nil) and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>1 end
	c:CancelToGrave()
	Duel.SendtoDeck(c,nil,2,REASON_RULE)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
--
function c1111009.op1(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():CancelToGrave()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,1,nil)
	if sg:GetCount()<1 then return end
	if Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)<1 then return end
	local tg=Duel.GetDecktopGroup(tp,2):Filter(c1111009.tfilter1,nil)
	if tg:GetCount()<1 then return end
	local gn=tg:Select(tp,1,1,nil)
	Duel.SendtoHand(gn,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,gn)
end
--
