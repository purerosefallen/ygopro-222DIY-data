--IDOL 五折
function c14804831.initial_effect(c)
	--link summon
	c:SetUniqueOnField(1,1,aux.FilterBoolFunction(Card.IsCode,14804831),LOCATION_MZONE)
	aux.AddLinkProcedure(c,nil,2)
	c:EnableReviveLimit()
	--effect gain
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c14804831.regcon)
	e1:SetOperation(c14804831.regop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c14804831.con1)
	e2:SetTarget(c14804831.target1)
	e2:SetOperation(c14804831.operation1)
	c:RegisterEffect(e2)
end
function c14804831.cfilter(c,tp)
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK) 
end
function c14804831.con1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c14804831.cfilter,1,nil,1-tp)
end
function c14804831.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(300)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,300)
end
function c14804831.operation1(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
function c14804831.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c14804831.matfilter(c)
	return c:IsSetCard(0x4848)
end
function c14804831.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetMaterial():Filter(c14804831.matfilter,nil)
	if g:GetCount()>=1 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetRange(LOCATION_MZONE)
		e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e1:SetTarget(c14804831.atktg)
		e1:SetValue(c14804831.atkval)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
		c:RegisterFlagEffect(0,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(14804831,1))
	end
	if g:GetCount()>=2 then
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(14804831,0))
		e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
		e2:SetType(EFFECT_TYPE_IGNITION)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCountLimit(1)
		e2:SetTarget(c14804831.sptg) 
		e2:SetOperation(c14804831.spop)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e2)
		c:RegisterFlagEffect(0,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(14804831,2))
	end
	if g:GetCount()>=3 then
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e3:SetRange(LOCATION_MZONE)
		e3:SetTargetRange(LOCATION_MZONE,0)
		e3:SetTarget(c14804831.imtg)
		e3:SetValue(1)
		c:RegisterEffect(e3)
		local e4=e3:Clone()
		e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e4:SetValue(aux.tgoval)
		c:RegisterEffect(e4)
		c:RegisterFlagEffect(0,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(14804831,3))
	end
end


function c14804831.atktg(e,c)
	return not c:IsSetCard(0x4848)
end
function c14804831.vfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x4848)
end
function c14804831.atkval(e,c)
	return Duel.GetMatchingGroupCount(c14804831.vfilter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)*-200
end

function c14804831.spfilter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x4848) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c14804831.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_PZONE) and chkc:IsControler(tp) and c14804831.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanDraw(1-tp,1) and Duel.IsExistingTarget(c14804831.spfilter,tp,LOCATION_PZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c14804831.spfilter,tp,LOCATION_PZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,1)
end
function c14804831.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		Duel.BreakEffect()
		Duel.Draw(1-tp,1,REASON_EFFECT)
	end
end

function c14804831.imtg(e,c)
	return c:IsSetCard(0x4848)
end