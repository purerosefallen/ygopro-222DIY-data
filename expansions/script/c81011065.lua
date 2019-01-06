--Answer·池袋晶叶·SIRIUS
function c81011065.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),10,2,nil,nil,99)
	c:EnableReviveLimit()
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81011065,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,81011065)
	e1:SetCost(c81011065.thcost)
	e1:SetTarget(c81011065.thtg)
	e1:SetOperation(c81011065.thop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81011065,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,81011965)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCondition(c81011065.tscon)
	e2:SetCost(c81011065.tscost)
	e2:SetTarget(c81011065.tstg)
	e2:SetOperation(c81011065.tsop)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(81011865,ACTIVITY_SPSUMMON,c81011065.counterfilter)
end
function c81011065.counterfilter(c)
	return c:IsAttribute(ATTRIBUTE_EARTH) and c:IsRace(RACE_MACHINE)
end
function c81011065.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetCustomActivityCount(81011865,tp,ACTIVITY_SPSUMMON)==0 and c:CheckRemoveOverlayCard(tp,1,REASON_COST) end
	local rt=math.min(Duel.GetTargetCount(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil),c:GetOverlayCount())
	c:RemoveOverlayCard(tp,1,rt,REASON_COST)
	local ct=Duel.GetOperatedGroup():GetCount()
	e:SetLabel(ct)
end
function c81011065.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local ct=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local tg=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,ct,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,tg,ct,0,0)
end
function c81011065.thop(e,tp,eg,ep,ev,re,r,rp,chk)
	local rg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if rg:GetCount()>0 then
		Duel.SendtoHand(rg,nil,REASON_EFFECT)
	end
end
function c81011065.tscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp
end
function c81011065.tscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(81011865,tp,ACTIVITY_SPSUMMON)==0 and e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c81011065.tsfilter(c,e)
	return c:IsAttribute(ATTRIBUTE_EARTH) and c:IsRace(RACE_MACHINE) and c:IsLevel(10)
		and c:IsCanBeEffectTarget(e) and c:IsAbleToHand()
end
function c81011065.tstg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local g=Duel.GetMatchingGroup(c81011065.tsfilter,tp,LOCATION_GRAVE,0,nil,e)
	if chk==0 then return g:GetClassCount(Card.GetCode)>=2 end
	local sg=Group.CreateGroup()
	for i=1,2 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g1=g:Select(tp,1,1,nil)
		g:Remove(Card.IsCode,nil,g1:GetFirst():GetCode())
		sg:Merge(g1)
	end
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,#sg,0,0)
end
function c81011065.tsop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(c81011065.indtg)
	e1:SetValue(1)
	Duel.RegisterEffect(e1,tp)
end
function c81011065.indtg(e,c)
	return c:IsAttribute(ATTRIBUTE_EARTH) and c:IsRace(RACE_MACHINE)
end
