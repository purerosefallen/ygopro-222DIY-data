--田中琴叶·Revolutia
function c81000068.initial_effect(c)
	c:SetUniqueOnField(1,0,81000068)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),3,3,c81000068.lcheck)
	c:EnableReviveLimit()
	--spsummon bgm
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81000068,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c81000068.sumcon)
	e1:SetOperation(c81000068.sumsuc)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,81000068)
	e2:SetTarget(c81000068.sptg)
	e2:SetOperation(c81000068.spop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=aux.AddRitualProcEqual2(c,c81000068.filter,nil,nil,c81000068.mfilter)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCode(0)
	e3:SetCountLimit(1,81000968)
	e3:SetRange(LOCATION_MZONE)
end
function c81000068.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c81000068.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(81000068,1))
end
function c81000068.lcheck(g,lc)
	return g:IsExists(c81000068.mzfilter,1,nil)
end
function c81000068.mzfilter(c)
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_PENDULUM)
end
function c81000068.filter(c)
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_PENDULUM)
end
function c81000068.mfilter(c,e,tp)
	return c~=e:GetHandler()
end
function c81000068.spfilter(c,ft)
	return c:IsFaceup() and c:IsType(TYPE_RITUAL) and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand() and (ft>0 or c:GetSequence()<5)
end
function c81000068.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c81000068.spfilter(chkc,ft) end
	if chk==0 then return Duel.IsExistingTarget(c81000068.spfilter,tp,LOCATION_MZONE,0,1,nil,ft)
		and ft>-1 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c81000068.spfilter,tp,LOCATION_MZONE,0,1,1,nil,ft)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c81000068.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
