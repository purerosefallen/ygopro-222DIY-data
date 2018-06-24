--『Ancient Duper』
function c11200071.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_REMAIN_FIELD)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,11200071)
	e2:SetTarget(c11200071.tg2)
	e2:SetOperation(c11200071.op2)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,11200071)
	e4:SetCost(c11200071.cost4)
	e4:SetTarget(c11200071.tg4)
	e4:SetOperation(c11200071.op4)
	c:RegisterEffect(e4)
--
end
--
function c11200071.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if not eg then return false end
	local tc=eg:GetFirst()
	if chkc then return chkc==tc end
	if chk==0 then return ep~=tp and tc:IsFaceup() and tc:GetAttack()>=1000 and tc:IsOnField() and tc:IsCanBeEffectTarget(e) end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,tc,1,0,0)
end
--
function c11200071.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=eg:GetFirst()
	if tc:IsFacedown() then return end
	if not tc:IsRelateToEffect(e) then return end
	local e2_1=Effect.CreateEffect(c)
	e2_1:SetType(EFFECT_TYPE_SINGLE)
	e2_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2_1:SetCode(EFFECT_DISABLE)
	e2_1:SetReset(RESET_EVENT+0x1fe0000)
	tc:RegisterEffect(e2_1)
	local e2_2=Effect.CreateEffect(c)
	e2_2:SetType(EFFECT_TYPE_SINGLE)
	e2_2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2_2:SetCode(EFFECT_DISABLE_EFFECT)
	e2_2:SetValue(RESET_TURN_SET)
	e2_2:SetReset(RESET_EVENT+0x1fe0000)
	tc:RegisterEffect(e2_2)
	local e2_3=Effect.CreateEffect(c)
	e2_3:SetType(EFFECT_TYPE_SINGLE)
	e2_3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2_3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e2_3:SetValue(1)
	e2_3:SetReset(RESET_EVENT+0x1fe0000)
	tc:RegisterEffect(e2_3)
	local e2_4=Effect.CreateEffect(c)
	e2_4:SetType(EFFECT_TYPE_SINGLE)
	e2_4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2_4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e2_4:SetValue(1)
	e2_4:SetReset(RESET_EVENT+0x1fe0000)
	tc:RegisterEffect(e2_4)
	local e2_5=Effect.CreateEffect(c)
	e2_5:SetType(EFFECT_TYPE_SINGLE)
	e2_5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2_5:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e2_5:SetValue(1)
	e2_5:SetReset(RESET_EVENT+0x1fe0000)
	tc:RegisterEffect(e2_5)
	local e2_6=Effect.CreateEffect(c)
	e2_6:SetType(EFFECT_TYPE_SINGLE)
	e2_6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2_6:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e2_6:SetValue(1)
	e2_6:SetReset(RESET_EVENT+0x1fe0000)
	tc:RegisterEffect(e2_6)
end
--
function c11200071.cost4(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReleasable() end
	Duel.Release(c,REASON_COST)
end
--
function c11200071.tfilter4(c)
	return c:IsSetCard(0x133) and c:IsSSetable(true) and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)) and not c:IsCode(11200071) 
end
function c11200071.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11200071.tfilter4,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,LOCATION_GRAVE)
end
--
function c11200071.ofilter4(c)
	return c:IsSSetable() and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)) and c:IsSetCard(0x133)
end
function c11200071.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local sg=Duel.SelectMatchingCard(tp,c11200071.ofilter4,tp,LOCATION_GRAVE,0,1,1,c)
	if sg:GetCount()<1 then return end
	Duel.SSet(tp,sg)
	Duel.ConfirmCards(1-tp,sg)
end
--
