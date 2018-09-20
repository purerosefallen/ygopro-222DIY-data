--LA SG Pride 克耶爾
function c12010014.initial_effect(c)
	--SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12010014,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,12010114)
	e2:SetCost(c12010014.cost)
	e2:SetTarget(c12010014.tgtg)
	e2:SetOperation(c12010014.tgop)
	c:RegisterEffect(e2)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12010014,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,12010214)
	e2:SetCost(c12010014.cost)
	e2:SetTarget(c12010014.tgtg)
	e2:SetOperation(c12010014.tgop)
	c:RegisterEffect(e2)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12010014,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,12010014)
	e1:SetCost(c12010014.ccost)
	e1:SetTarget(c12010014.ctarget)
	e1:SetOperation(c12010014.coperation)
	c:RegisterEffect(e1)
end
function c12010014.cfilter(c,tc,tp)
	return c:IsSetCard(0xfba) and c:IsType(TYPE_MONSTER) and c:IsReleasable() and Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(c,tc))>0
end
function c12010014.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() and Duel.IsExistingMatchingCard(c12010014.cfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,c,tc,tp) end
	local tc=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,c12010014.cfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,1,c,tc,tp)
	g:AddCard(tc)
	Duel.Release(g,REASON_COST)
end
function c12010014.tgfilter(c,e,tp)
	return c:IsSetCard(0xfba) and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,true,false)
end
function c12010014.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c12010014.tgfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c12010014.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c12010014.tgfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		Duel.SpecialSummon(g,SUMMON_TYPE_XYZ,tp,tp,true,false,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
function c12010014.ccfilter(c)
	return c:IsSetCard(0xfba) and c:IsAbleToRemoveAsCost() and c:IsType(TYPE_MONSTER)
end
function c12010014.ccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12010014.ccfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c12010014.ccfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c12010014.ctarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c12010014.coperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
