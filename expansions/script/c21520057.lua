--灵子殖装-夺魂翼
function c21520057.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,21520057+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c21520057.condition)
	e1:SetTarget(c21520057.target)
	e1:SetOperation(c21520057.operation)
	c:RegisterEffect(e1)
	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(c21520057.eqlimit)
	c:RegisterEffect(e2)
	--control
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_SET_CONTROL)
	e3:SetValue(c21520057.ctval)
	c:RegisterEffect(e3)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(21520057,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c21520057.spcon)
	e4:SetCost(c21520057.spcost)
	e4:SetTarget(c21520057.sptg)
	e4:SetOperation(c21520057.spop)
	c:RegisterEffect(e4)
end
function c21520057.eqlimit(e,c)
	return e:GetHandler():GetEquipTarget()==c
end
function c21520057.efilter(c)
	return c:IsSetCard(0x494) and c:GetCode()~=21520057 and c:IsFaceup()
end
function c21520057.filter(c,e)
	return c:IsCanBeEffectTarget(e) and c:IsFaceup()
end
function c21520057.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c21520057.efilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end
function c21520057.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c21520057.filter(chkc,e) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c21520057.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
function c21520057.ctval(e,c)
	return e:GetHandlerPlayer()
end
function c21520057.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x494)
end
function c21520057.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetEquipTarget()~=nil and e:GetHandler():GetEquipTarget():GetControler()==tp and e:GetHandler():GetEquipTarget():IsReleasable()
end
function c21520057.spcost(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c21520057.spfilter(chkc,e,tp) and e:GetHandler():GetEquipTarget():IsReleasable() end
	if chk==0 then return e:GetHandler():GetEquipTarget():IsReleasable() end
	Duel.Release(e:GetHandler():GetEquipTarget(),REASON_COST)
end
function c21520057.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c21520057.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingMatchingCard(c21520057.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.IsPlayerCanSpecialSummon(tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c21520057.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	g:GetFirst():RegisterFlagEffect(21520057,RESET_EVENT+0x1f80000+RESET_PHASE+PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,LOCATION_GRAVE)
end
function c21520057.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:GetFlagEffect(21520057)~=0 and tc:IsLocation(LOCATION_GRAVE) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		tc:ResetFlagEffect(21520057)
	end
end
