--幻层驱动 超Ω构筑
function c10130009.initial_effect(c)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_DECK+LOCATION_GRAVE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--postion
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10130009,0))
	e2:SetCategory(CATEGORY_POSITION+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,10130009)
	e2:SetCost(c10130009.descost)
	e2:SetTarget(c10130009.destg)
	e2:SetOperation(c10130009.desop)
	c:RegisterEffect(e2) 
	--flip
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10130009,1))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_FLIP)
	e3:SetCountLimit(1,10130109)
	e3:SetTarget(c10130009.rmtg)
	e3:SetOperation(c10130009.rmop)
	c:RegisterEffect(e3)  
	local e4=e3:Clone()
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(c10130009.rmcon)
	c:RegisterEffect(e4) 
end
function c10130009.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c10130009.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and Card.IsAbleToRemove(chkc) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c10130009.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then 
	   Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
function c10130009.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanTurnSet() end
	if Duel.ChangePosition(e:GetHandler(),POS_FACEDOWN_DEFENSE)~=0 then
	   local sg=Duel.GetMatchingGroup(c10130009.ssfilter,tp,LOCATION_MZONE,0,nil)
	   Duel.ShuffleSetCard(sg)
	end
end
function c10130009.ssfilter(c)
	return c:IsFacedown() and c:GetSequence()<5
end
function c10130009.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
end
function c10130009.setfilter(c,e,tp,code)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xa336) and not c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
end
function c10130009.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 and Duel.Destroy(g,REASON_EFFECT)~=0 then
	   local sg=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_MZONE,0,nil)
	   if sg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(10130009,2)) then
		  Duel.BreakEffect()
		  Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_FACEDOWN)
		  local pg=sg:Select(1-tp,1,1,nil)
		  Duel.HintSelection(g)
		  Duel.ChangePosition(pg,POS_FACEUP_DEFENSE)
	   end
	end
end