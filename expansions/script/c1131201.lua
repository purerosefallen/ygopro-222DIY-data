--梨花道场
local m=1131201
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c1110198") end,function() require("script/c1110198") end)
--
function c1131201.initial_effect(c)
--
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(c1131201.con1)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c1131201.tg1)
	e1:SetValue(c1131201.val1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1131201,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,1131201)
	e2:SetCondition(c1131201.con2)
	e2:SetTarget(c1131201.tg2)
	e2:SetOperation(c1131201.op2)
	c:RegisterEffect(e2)
--
end
--
function c1131201.con1(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
--
function c1131201.tg1(e,c)
	return muxu.check_set_Hinbackc(c) and c:IsType(TYPE_MONSTER) and (c:IsFaceup() or c:IsPublic())
end
--
function c1131201.val1(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:IsActiveType(TYPE_MONSTER)
end
--
function c1131201.cfilter2(c)
	return muxu.check_set_Hinbackc(c) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function c1131201.con2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c1131201.cfilter2,1,nil)
		and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)<1
end
--
function c1131201.tfilter2(c,e,tp)
	return muxu.check_set_Hinbackc(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:GetLevel()==4
end
function c1131201.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c1131201.tfilter2,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
--
function c1131201.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c1131201.tfilter2,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if sg:GetCount()<1 then return end
	local sc=sg:GetFirst()
	if Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local e2_1=Effect.CreateEffect(sc)
		e2_1:SetType(EFFECT_TYPE_SINGLE)
		e2_1:SetCode(EFFECT_UPDATE_ATTACK)
		e2_1:SetValue(600)
		e2_1:SetReset(RESET_EVENT+0x1fe0000)
		sc:RegisterEffect(e2_1,true)
		local e2_2=Effect.CreateEffect(sc)
		e2_2:SetDescription(aux.Stringid(1131201,1))
		e2_2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e2_2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e2_2:SetCode(EVENT_BATTLED)
		e2_2:SetOperation(c1131201.op2_2)
		e2_2:SetReset(RESET_EVENT+0x1fe0000)
		sc:RegisterEffect(e2_2,true)
		local e2_3=Effect.CreateEffect(sc)
		e2_3:SetDescription(aux.Stringid(1131201,2))
		e2_3:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e2_3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e2_3:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
		e2_3:SetOperation(c1131201.op2_3)
		e2_3:SetReset(RESET_EVENT+0x1fe0000)
		sc:RegisterEffect(e2_3,true)
	end
end
--
function c1131201.op2_2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	local e2_2_1=Effect.CreateEffect(c)
	e2_2_1:SetType(EFFECT_TYPE_SINGLE)
	e2_2_1:SetCode(EFFECT_DISABLE)
	e2_2_1:SetReset(RESET_EVENT+0x17a0000)
	bc:RegisterEffect(e2_2_1)
	local e2_2_2=Effect.CreateEffect(c)
	e2_2_2:SetType(EFFECT_TYPE_SINGLE)
	e2_2_2:SetCode(EFFECT_DISABLE_EFFECT)
	e2_2_2:SetReset(RESET_EVENT+0x17a0000)
	bc:RegisterEffect(e2_2_2)
end
--
function c1131201.op2_3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if d==c then a,d=d,a end
	if a~=c or not d or d:IsControler(tp) or not d:IsRelateToBattle() then return end
	local da=d:GetTextAttack()
	local dd=d:GetTextDefense()
	if d:IsImmuneToEffect(e) then 
		da=d:GetBaseAttack()
		dd=d:GetBaseDefense() 
	end
	if da<0 then da=0 end
	if dd<0 then dd=0 end
	local e2_3_1=Effect.CreateEffect(c)
	e2_3_1:SetType(EFFECT_TYPE_SINGLE)
	e2_3_1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2_3_1:SetRange(LOCATION_MZONE)
	e2_3_1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e2_3_1:SetValue(da)
	e2_3_1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	d:RegisterEffect(e2_3_1)
	local e2_3_2=Effect.CreateEffect(c)
	e2_3_2:SetType(EFFECT_TYPE_SINGLE)
	e2_3_2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2_3_2:SetRange(LOCATION_MZONE)
	e2_3_2:SetCode(EFFECT_SET_DEFENSE_FINAL)
	e2_3_2:SetValue(dd)
	e2_3_2:SetReset(RESET_PHASE+PHASE_DAMAGE)
	d:RegisterEffect(e2_3_2)
end
--
