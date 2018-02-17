--幻层驱动 超Ψ构筑
function c10130010.initial_effect(c)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_DECK+LOCATION_GRAVE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--control
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10130010,0))
	e2:SetCategory(CATEGORY_CONTROL+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,10130010)
	e2:SetCost(c10130010.ccost)
	e2:SetTarget(c10130010.ctg)
	e2:SetOperation(c10130010.cop)
	c:RegisterEffect(e2) 
	--flip
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10130010,1))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,10130110)
	e3:SetCode(EVENT_FLIP)
	e3:SetOperation(c10130010.disop)
	c:RegisterEffect(e3) 
	local e4=e3:Clone()
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCondition(c10130010.discon)
	e4:SetCode(EVENT_TO_GRAVE)
	c:RegisterEffect(e4) 
end
function c10130010.discon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c10130010.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_TO_HAND)
	e1:SetCondition(c10130010.dcon)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	e1:SetTargetRange(0,LOCATION_DECK+LOCATION_EXTRA+LOCATION_GRAVE)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCondition(c10130010.dcon)
	e2:SetCode(EFFECT_CANNOT_DRAW)
	e2:SetReset(RESET_PHASE+PHASE_END,2)
	e2:SetTargetRange(0,1)
	Duel.RegisterEffect(e2,tp)
end
function c10130010.dcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c10130010.ccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanTurnSet() end
	if Duel.ChangePosition(e:GetHandler(),POS_FACEDOWN_DEFENSE)~=0 then
	   local sg=Duel.GetMatchingGroup(c10130010.ssfilter,tp,LOCATION_MZONE,0,nil)
	   Duel.ShuffleSetCard(sg)
	end
end
function c10130010.ssfilter(c)
	return c:IsFacedown() and c:GetSequence()<5
end
function c10130010.ctg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsControlerCanBeChanged() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c10130010.cop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.GetControl(tc,tp,PHASE_END,1)~=0 then
	   local sg=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_MZONE,0,nil)
	   if sg:GetCount()>0 then
		  Duel.BreakEffect()
		  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY) 
		  local dg=Duel.SelectMatchingCard(1-tp,Card.IsFacedown,1-tp,LOCATION_MZONE,0,1,1,nil)
		  Duel.Destroy(dg,REASON_EFFECT)
	   end
	end
end