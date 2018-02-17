--幻层驱动 硬化层
function c10130004.initial_effect(c)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10130008,0))
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_POSITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e1:SetCountLimit(1,10130004)
	e1:SetTarget(c10130004.netg)
	e1:SetOperation(c10130004.neop)
	c:RegisterEffect(e1) 
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10130004,1))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,10130104)
	e2:SetCondition(c10130004.tgcon)
	e2:SetTarget(c10130004.tgtg)
	e2:SetOperation(c10130004.tgop)
	c:RegisterEffect(e2)
	c10130004.flip_effect=e1
end
function c10130004.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) and e:GetHandler():IsPreviousPosition(POS_FACEDOWN)
end
function c10130004.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c10130004.tgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10130004.tgfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c10130004.tgfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function c10130004.tgfilter(c)
	return c:IsFacedown() and c:IsAbleToGrave()
end
function c10130004.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tc,c=Duel.GetFirstTarget(),e:GetHandler()
	if tc:IsRelateToEffect(e) and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) and c:IsLocation(LOCATION_GRAVE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(10130004,2)) then
		Duel.BreakEffect()
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)~=0 then
		   Duel.ConfirmCards(1-tp,g)
		   local sg=Duel.GetMatchingGroup(c10130004.ssfilter,tp,LOCATION_MZONE,0,nil)
		   Duel.ShuffleSetCard(sg)
		end
	end
end
function c10130004.netg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and aux.disfilter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(aux.disfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,aux.disfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,g:GetCount(),0,0)
end
function c10130004.nefilter(c,e)
	return c:IsRelateToEffect(e) and ((c:IsFaceup() and not c:IsDisabled()) or c:IsType(TYPE_TRAPMONSTER))
end
function c10130004.neop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if ((tc:IsFaceup() and not tc:IsDisabled()) or tc:IsType(TYPE_TRAPMONSTER)) and tc:IsRelateToEffect(e) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
		   local e3=Effect.CreateEffect(c)
		   e3:SetType(EFFECT_TYPE_SINGLE)
		   e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
		   e3:SetReset(RESET_EVENT+0x1fe0000)
		   tc:RegisterEffect(e3)
		end
	end
	if tc:IsDisabled() and not c:IsStatus(STATUS_BATTLE_DESTROYED) and c:IsCanTurnSet() and Duel.SelectYesNo(tp,aux.Stringid(10130004,2)) then
	   Duel.BreakEffect()
	   Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
	   local sg=Duel.GetMatchingGroup(c10130004.ssfilter,tp,LOCATION_MZONE,0,nil)
	   Duel.ShuffleSetCard(sg)
	end
end
function c10130004.ssfilter(c)
	return c:IsFacedown() and c:GetSequence()<5
end