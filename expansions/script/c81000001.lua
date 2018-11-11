--Answer·箱崎星梨花
c81000001.dfc_front_side=81000001
c81000001.dfc_back_side=81000002
function c81000001.initial_effect(c)
	--banish extra
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81000001,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,81000001)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c81000001.excost)
	e1:SetTarget(c81000001.extg)
	e1:SetOperation(c81000001.exop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81000001,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,81000901)
	e2:SetCost(c81000001.cost)
	e2:SetTarget(c81000001.target)
	e2:SetOperation(c81000001.operation)
	c:RegisterEffect(e2)
end
function c81000001.excost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c81000001.extg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_EXTRA,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_EXTRA)
end
function c81000001.exop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
	Duel.ConfirmCards(tp,g)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:FilterSelect(tp,Card.IsAbleToRemove,1,1,nil)
	Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT)
end
function c81000001.cfilter(c,ft)
	return c:IsCode(81000001) and c:IsAbleToGraveAsCost()
		and (ft>0 or c:GetSequence()<5)
end
function c81000001.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local loc=LOCATION_MZONE
	if ft==0 then loc=LOCATION_MZONE end
	if chk==0 then return ft>-1 and Duel.IsExistingMatchingCard(c81000001.cfilter,tp,loc,0,1,nil,ft) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c81000001.cfilter,tp,loc,0,1,1,nil,ft)
	Duel.Remove(g,POS_FACEDOWN,REASON_COST)
end
function c81000001.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c81000001.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		Duel.Hint(HINT_MUSIC,0,aux.Stringid(81000002,1))
	end
		local c=e:GetHandler()
		local tcode=c.dfc_back_side
		c:SetEntityCode(tcode,true)
		c:ReplaceEffect(tcode,0,0)
end
