--猫耳天堂-新店开业
function c4210010.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(4210010,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c4210010.target)
	e2:SetOperation(c4210010.operation)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(4210010,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)end)
	e3:SetTarget(c4210010.sptg2)
	e3:SetOperation(c4210010.spop2)
	--effect gain
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(c4210010.eftg)
	e4:SetLabelObject(e3)
	c:RegisterEffect(e4)
end
function c4210010.filter(c,e,sp)
	return c:IsSetCard(0x2af) and c:IsCanBeSpecialSummoned(e,0,sp,false,false)
end
function c4210010.cfilter(c,e)
	return c==e:GetHandler()
end
function c4210010.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,math.ceil(2^e:GetHandler():GetSequence()))>0 
			and Duel.IsExistingMatchingCard(c4210010.filter,tp,LOCATION_HAND,0,1,nil,e,tp,math.ceil(2^e:GetHandler():GetSequence()))
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c4210010.operation(e,tp,eg,ep,ev,re,r,rp)
	local cells = {5242913,4718626,2359332,2228296,2162768}
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local zone = math.ceil(e:GetHandler():GetSequence())
	local g=Duel.SelectMatchingCard(tp,c4210010.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		local tc = g:GetFirst()
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP,cells[zone+1])
		tc:RegisterFlagEffect(0,RESET_EVENT+0xcff0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(4210010,1))
		tc:RegisterFlagEffect(4210010,RESET_EVENT+0xcff0000,0,0)
	end	
end
function c4210010.spfilter2(c,e,tp)
	return c:IsSetCard(0x2af) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c4210010.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c4210010.spfilter2,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c4210010.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c4210010.spfilter2,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c4210010.eftg(e,c)
	local g=e:GetHandler():GetColumnGroup(1,1)
	local sg=e:GetHandler():GetColumnGroup()
	return c:IsType(TYPE_EFFECT) and c:IsSetCard(0x2af) and c:GetFlagEffect(4210010)~=0
		and c:GetSequence()<5 and g:IsContains(c) and not sg:IsContains(c)
end