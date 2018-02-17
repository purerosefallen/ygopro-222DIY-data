--幻层驱动 壳层
function c10130003.initial_effect(c)
	--Destroy1
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_POSITION)
	e1:SetDescription(aux.Stringid(10130003,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,10130003)
	e1:SetTarget(c10130003.destg)
	e1:SetOperation(c10130003.desop)
	c:RegisterEffect(e1) 
	--Destroy2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10130003,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,10130103)
	e2:SetCost(c10130003.descon)
	e2:SetTarget(c10130003.destg2)
	e2:SetOperation(c10130003.desop2)
	c:RegisterEffect(e2)
	c10130003.flip_effect=e1
end
function c10130003.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) and e:GetHandler():IsPreviousPosition(POS_FACEDOWN)
end
function c10130003.destg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c10130003.desop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
	if g:GetCount()>0 then
	   Duel.HintSelection(g)
	   if Duel.Destroy(g,REASON_EFFECT)==0 then return end
	   local tc=g:GetFirst()
	   if tc:IsLocation(LOCATION_HAND+LOCATION_DECK) or tc:IsHasEffect(EFFECT_NECRO_VALLEY) then return end
	   local sset=c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
	   local mset=c:IsType(TYPE_MONSTER) and not c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetLocationCountFromEx(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
	   local eset=c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
	   local sg=Duel.GetMatchingGroup(c10130003.ssfilter,tp,LOCATION_MZONE,0,nil)
	   if ((sg:GetCount()>0 and sset) or mset or (eset and sg:GetCount()>0) and Duel.SelectYesNo(tp,aux.Stringid(10130003,1))) then
		  Duel.BreakEffect()
		  if sset then
			 Duel.SSet(tp,tc)
		  else
			 Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
		  end
		  Duel.ConfirmCards(1-tp,tc)
		  sg=Duel.GetMatchingGroup(c10130003.ssfilter,tp,LOCATION_MZONE,0,nil)
		  Duel.ShuffleSetCard(sg)
	   end
	end
end
function c10130003.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c10130003.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc,c=Duel.GetFirstTarget(),e:GetHandler()
	if tc and tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 and not c:IsStatus(STATUS_BATTLE_DESTROYED) and c:IsCanTurnSet() and Duel.SelectYesNo(tp,aux.Stringid(10130003,2)) and Duel.ChangePosition(c,POS_FACEDOWN_DEFENSE)~=0 then
	   Duel.ConfirmCards(1-tp,c)
	   local sg=Duel.GetMatchingGroup(c10130003.ssfilter,tp,LOCATION_MZONE,0,nil)
	   Duel.ShuffleSetCard(sg)
	end
end
function c10130003.ssfilter(c)
	return c:IsFacedown() and c:GetSequence()<5
end