--LA SGA  仁慈的貝露塔
function c12010041.initial_effect(c)
	c:SetUniqueOnField(1,0,12010041)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c12010041.ffilter,aux.FilterBoolFunction(Card.IsAttackBelow,2000),true)
	--fusion success
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(12010041,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,12010041)
	e3:SetCondition(c12010041.thcon)
	e3:SetTarget(c12010041.thtg)
	e3:SetOperation(c12010041.thop)
	c:RegisterEffect(e3)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12010041,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(3,12010141)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c12010041.spcost)
	e1:SetTarget(c12010041.sptg)
	e1:SetOperation(c12010041.spop)
	c:RegisterEffect(e1)
end
function c12010041.ffilter(c)
	return c:IsFusionSetCard(0xfba) and c:IsRace(RACE_MACHINE)
end
function c12010041.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c12010041.thfilter(c)
	return c:IsSetCard(0xfbc) and c:IsAbleToHand() and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP))
end
function c12010041.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12010041.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
end
function c12010041.thop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c12010041.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) then return false end
	local g=Duel.SelectMatchingCard(tp,c12010041.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		if Duel.SendtoHand(g,nil,REASON_EFFECT) then
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function c12010041.cfilter(c)
	return c:IsSetCard(0xfba) and c:IsReleasable()
end
function c12010041.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12010041.cfilter,tp,LOCATION_MZONE,0,1,nil) end
	local cg=Duel.SelectMatchingCard(tp,c12010041.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Release(cg,REASON_COST)
end
function c12010041.spfilter(c,e,tp)
	return c:IsSetCard(0xfba) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(12010041)
end
function c12010041.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c12010041.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,0,1,0,0)
end
function c12010041.spop(e,tp,eg,ep,ev,re,r,rp,chk)
	if not Duel.IsExistingMatchingCard(c12010041.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) then return false end
	local sg=Duel.SelectMatchingCard(tp,c12010041.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if sg:GetCount()>0 then
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end