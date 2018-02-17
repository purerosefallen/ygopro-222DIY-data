--幻层驱动 填充层
function c10130005.initial_effect(c)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10130005,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,10130005)
	e1:SetTarget(c10130005.settg)
	e1:SetOperation(c10130005.setop)
	c:RegisterEffect(e1) 
	--position
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetDescription(aux.Stringid(10130005,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCountLimit(1,10130105)
	e2:SetCost(c10130005.poscost)
	e2:SetTarget(c10130005.postg)
	e2:SetOperation(c10130005.posop)
	c:RegisterEffect(e2)
	c10130005.flip_effect=e1
end
function c10130005.poscost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsPublic() end
	Duel.ConfirmCards(1-tp,c)
end
function c10130005.posfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xa336) and c:IsCanTurnSet()
end
function c10130005.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c10130005.posfilter(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(c10130005.posfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEDOWN)
	local g=Duel.SelectTarget(tp,c10130005.posfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),tp,0)
end
function c10130005.posop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)~=0 and Duel.SelectYesNo(tp,aux.Stringid(10130005,2)) then
	   local sg=Duel.GetMatchingGroup(c10130005.ssfilter,tp,LOCATION_MZONE,0,nil)
	   Duel.BreakEffect()
	   Duel.ShuffleSetCard(sg)
	end
end
function c10130005.setfilter(c,e,tp)
	return ((c:IsType(TYPE_MONSTER) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE))) or (c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable())
end
function c10130005.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(1-tp) and c10130005.setfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c10130005.setfilter,tp,0,LOCATION_GRAVE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectTarget(tp,c10130005.setfilter,tp,0,LOCATION_GRAVE,1,1,nil,e,tp)
	if g:GetFirst():IsType(TYPE_MONSTER) then
	   e:SetCategory(CATEGORY_SPECIAL_SUMMON)
	end
end
function c10130005.setop(e,tp,eg,ep,ev,re,r,rp)
	local tc,ct=Duel.GetFirstTarget(),0
	if not tc:IsRelateToEffect(e) then return end
	if tc:IsType(TYPE_MONSTER) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
	   ct=Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
	elseif tc:IsSSetable() then
	   ct=Duel.SSet(tp,Group.FromCards(tc))
	end
	if ct>0 then
	   Duel.ConfirmCards(1-tp,tc)
	   local sg=Duel.GetMatchingGroup(c10130005.ssfilter,tp,LOCATION_MZONE,0,nil)
	   if sg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(10130005,2)) then
		  Duel.BreakEffect()
		  Duel.ShuffleSetCard(sg)
	   end
	end
end
function c10130005.ssfilter(c)
	return c:IsFacedown() and c:GetSequence()<5
end