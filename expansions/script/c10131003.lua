--自由斗士·持剑的涅法格
function c10131003.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c,true)
	--pe
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10131003,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetRange(LOCATION_PZONE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,10131003)
	e1:SetTarget(c10131003.pctg)
	e1:SetOperation(c10131003.pcop)
	c:RegisterEffect(e1)
	--sp
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10131003,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c10131003.sptg)
	e2:SetOperation(c10131003.spop)
	c:RegisterEffect(e2)
end
function c10131003.pctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c10131003.pcfilter,1,nil,e,tp) end
	Duel.SetTargetCard(eg)
end
function c10131003.pcfilter(c,e,tp)
	return c:IsSetCard(0x5338) and c:IsType(TYPE_PENDULUM) and c:GetPreviousControler()==tp and ((c:IsCanBeSpecialSummoned(e,0,sp,false,false) and ((c:IsLocation(LOCATION_EXTRA) and GetLocationCountFromEx(tp)>0) or ( not c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0))) or (not c:IsForbidden() and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))))
end
function c10131003.pcfilter2(c,e,tp)
	return c10131003.pcfilter(c,e,tp) and c:IsRelateToEffect(e)
end
function c10131003.pcop(e,tp,eg,ep,ev,re,r,rp)
	local c,ft,pc=e:GetHandler(),Duel.GetLocationCount(tp,LOCATION_MZONE),(Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(c10131003.pcfilter2,nil,e,tp)
	if not tg:GetCount()>0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(10131003,0))
	local tc=tg:Select(tp,1,1,nil):GetFirst()
	if tc then
		if ft>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
			and (not pc or Duel.SelectYesNo(tp,aux.Stringid(10131003,2))) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		else
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) 
		end
	end
end
function c10131003.spfilter(c,e,sp)
	return c:IsSetCard(0x5338) and c:GetLevel()==4 and c:IsCanBeSpecialSummoned(e,0,sp,false,false) and (c:IsFaceup() or c:IsLocation(LOCATION_HAND)) and c:IsType(TYPE_PENDULUM)
end
function c10131003.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c10131003.spfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_EXTRA)
end
function c10131003.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10131003.spfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
	   Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	end
end
