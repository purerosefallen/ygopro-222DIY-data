--小黄
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m=12030007
local cm=_G["c"..m]
cm.rssetcode="yatori"
function c12030007.initial_effect(c)
	--negate effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12030007,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1)
	e1:SetTarget(c12030007.target)
	e1:SetOperation(c12030007.operation)
	c:RegisterEffect(e1)
	 --to deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12030007,1))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetTarget(c12030007.distg)
	e2:SetOperation(c12030007.disop)
	c:RegisterEffect(e2)
	--copy Archetype
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(12030007,2))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c12030007.drcon)
	e3:SetTarget(c12030007.drtg)
	e3:SetOperation(c12030007.drop)
	c:RegisterEffect(e3)
end
function c12030007.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=( Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp) and Duel.IsExistingTarget(aux.disfilter1,tp,0,LOCATION_MZONE,1,nil) )
	local b2=( Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingTarget(aux.disfilter1,tp,LOCATION_MZONE,0,1,nil) )
	if chk==0 then
		return b1 or b2  end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	if b1 and b2 then
		Duel.SelectTarget(tp,aux.disfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	elseif b1 and not b2 then
		Duel.SelectTarget(tp,aux.disfilter1,tp,0,LOCATION_MZONE,1,1,nil)
	else
		Duel.SelectTarget(tp,aux.disfilter1,tp,LOCATION_MZONE,0,1,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c12030007.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	  if  tc:GetControler()==tp then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsRelateToEffect(e) then
		   Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		end
	  else
		if Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and c:IsRelateToEffect(e) then
		   Duel.SpecialSummon(c,0,tp,1-tp,false,false,POS_FACEUP)
		end
	  end
	end
end
function c12030007.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	 if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,tp,1)
end
function c12030007.disfilter(c)
	return c:IsAbleToDeck()
end
function c12030007.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.IsExistingMatchingCard(c12030007.disfilter,tp,LOCATION_GRAVE,0,1,nil) then
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	   local tc=Duel.SelectMatchingCard(tp,c12030007.disfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	   Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	end
	if Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)==0 and c:IsFaceup() and c:IsRelateToEffect(e) then
	   local e1=Effect.CreateEffect(e:GetHandler())
	   e1:SetDescription(aux.Stringid(12030007,4))
	   e1:SetType(EFFECT_TYPE_FIELD)
	   e1:SetCode(EFFECT_CANNOT_TO_HAND)
	   e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	   e1:SetTargetRange(1,1)
	   e1:SetTarget(aux.TargetBoolFunction(Card.IsLocation,LOCATION_DECK))
	   c:RegisterEffect(e1)
	   local e2=Effect.CreateEffect(e:GetHandler())
	   e2:SetType(EFFECT_TYPE_FIELD)
	   e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	   e2:SetCode(EFFECT_CANNOT_DRAW)
	   e2:SetTargetRange(1,1)
	   c:RegisterEffect(e2)
	end
end
function c12030007.drcon(e,tp,eg,ep,ev,re,r,rp)
	e:SetLabel(e:GetHandler():GetPreviousControler())
	return e:GetHandler():IsReason(REASON_EFFECT)
end
function c12030007.cfilter(c)
	return c:IsFaceup() and c:IsDisabled() and c:IsAbleToChangeControler()
end
function c12030007.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
end
function c12030007.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		Duel.BreakEffect()
		if  rp==1-tp and tp==e:GetLabel() and Duel.SelectYesNo(tp,aux.Stringid(12030007,3)) then 
		   local g=Duel.GetMatchingGroup(c12030007.cfilter,tp,0,LOCATION_MZONE,nil)
		   local tc=g:GetFirst()
		   while tc do
				 Duel.GetControl(tc,tp)
				 end 
		   tc=g:GetNext()
		end
	 end
end