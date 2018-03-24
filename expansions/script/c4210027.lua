--猫耳天堂-猫耳变化
function c4210027.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c4210027.target)
	e1:SetOperation(c4210027.activate)
	c:RegisterEffect(e1)
end
function c4210027.tfilter(c,att,e,tp)
	return c:IsSetCard(0x2af) and not c:IsAttribute(att) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c4210027.filter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x2af)
		and Duel.IsExistingMatchingCard(c4210027.tfilter,tp,LOCATION_DECK,0,1,nil,c:GetAttribute(),e,tp)
end
function c4210027.chkfilter(c,att)
	return c:IsFaceup() and c:IsSetCard(0x2af) and c:IsType(TYPE_MONSTER) and not c:IsAttribute(att)
end
function c4210027.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c4210027.chkfilter(chkc,e:GetLabel()) end
	if chk==0 then return Duel.IsExistingTarget(c4210027.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectTarget(tp,c4210027.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	e:SetLabel(g:GetFirst():GetAttribute())
	if(g:GetFirst():GetFlagEffect(4210010)~=0)then 
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500)
	end	
end
function c4210027.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local att=tc:GetAttribute()
	local dmg = false
	if tc:GetFlagEffect(4210010)~=0 then dmg = true end
	if Duel.Release(tc,REASON_EFFECT)~=0 and dmg  then 	Duel.Damage(1-tp,800,REASON_EFFECT)	end
	if Duel.GetLocationCountFromEx(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c4210027.tfilter,tp,LOCATION_DECK,0,1,1,nil,att,e,tp)
	if sg:GetCount()>0 then
		Duel.BreakEffect()
		Duel.SpecialSummon(sg,0,tp,tp,true,false,POS_FACEUP)
		local c = sg:GetFirst()		
		c:RegisterFlagEffect(0,RESET_EVENT+0xcff0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(4210010,1))
		c:RegisterFlagEffect(4210010,RESET_EVENT+0xcff0000,0,0)
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(4210027,1))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetCode(EFFECT_INDESTRUCTABLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0xcff0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end