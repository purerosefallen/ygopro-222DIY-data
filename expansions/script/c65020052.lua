--暮色居城的过往
function c65020052.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,65020052)
	e1:SetTarget(c65020052.target)
	e1:SetOperation(c65020052.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,65020052)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c65020052.tdtg)
	e2:SetOperation(c65020052.tdop)
	c:RegisterEffect(e2)
end
function c65020052.tdfil(c)
	return c:IsFacedown() and c:IsAbleToDeck()
end
function c65020052.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65020052.tdfil,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_REMOVED)
end
function c65020052.setfil(c)
	return c:IsSetCard(0x5da1) and c:IsFaceup()
end
function c65020052.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c65020052.setfil,tp,LOCATION_MZONE,0,nil)
	local num=0
	local tc=g:GetFirst()
	while tc do
		local lv=tc:GetLevel()
		num=num+lv
		tc=g:GetNext()
	end
	local nu=Duel.GetMatchingGroupCount(c65020052.tdfil,tp,LOCATION_REMOVED,0,nil)
	if nu<num then num=nu end
	local g=Duel.SelectMatchingCard(tp,c65020052.tdfil,tp,LOCATION_REMOVED,0,1,num,nil)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end


function c65020052.filter(c,tp)
	local att=c:GetAttribute()
	local rac=c:GetRace()
	return c:IsSetCard(0x5da1) and Duel.IsExistingMatchingCard(c65020052.thfil,tp,LOCATION_DECK,0,1,nil,att,rac) and c:IsFaceup()
end
function c65020052.thfil(c,att,rac)
	return c:IsSetCard(0x5da1) and c:IsType(TYPE_MONSTER) and (not c:IsAttribute(att) or not c:IsRace(rac)) and c:IsAbleToHand()
end
function c65020052.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c65020052.filter(chkc,tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(c65020052.filter,tp,LOCATION_MZONE,0,1,nil,tp) end
	local g=Duel.SelectTarget(tp,c65020052.filter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c65020052.refil(c)
	return c:IsAbleToRemove() and not c:IsType(TYPE_TOKEN)
end
function c65020052.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local att=tc:GetAttribute()
	local rac=tc:GetRace()
	if tc:IsRelateToEffect(e) and Duel.IsExistingMatchingCard(c65020052.thfil,tp,LOCATION_DECK,0,1,nil,att,rac) then
		local g=Duel.SelectMatchingCard(tp,c65020052.thfil,tp,LOCATION_DECK,0,1,1,nil,att,rac)
		Duel.SendtoHand(g,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end