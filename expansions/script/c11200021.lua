--狂气的月兔 铃仙·优昙华院·因幡
function c11200021.initial_effect(c)
--
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c11200021.mfilter,2)
--
	if not c11200021.global_check then
		c11200021.global_check=true
		local e0=Effect.GlobalEffect()
		e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e0:SetCode(EVENT_CHAINING)
		e0:SetCondition(c11200021.con0)
		e0:SetOperation(c11200021.op0)
		Duel.RegisterEffect(e0,0)
	end
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11200021,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,11200021)
	e1:SetCondition(c11200021.con1)
	e1:SetCost(c11200021.cost1)
	e1:SetTarget(c11200021.tg1)
	e1:SetOperation(c11200021.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11200021,0))
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,11200021)
	e2:SetCondition(c11200021.con2)
	e2:SetOperation(c11200021.op2)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_ADD_CODE)
	e3:SetValue(11200019)
	c:RegisterEffect(e3)
--
end
--
function c11200021.mfilter(c)
	return c:IsLinkRace(RACE_BEAST) and not c:IsLinkType(TYPE_TOKEN)
end
--
function c11200021.con0(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and not re:GetHandler():IsCode(11200019)
end
--
function c11200021.op0(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(rp,11200021,0,0,0)
end
--
function c11200021.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,11200021)<1
end
--
function c11200021.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReleasable() end
	Duel.Release(c,REASON_COST)
end
--
function c11200021.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
--
function c11200021.op1(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
--
function c11200021.cfilter2(c,e,rp)
	return c:IsSetCard(0x132) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,rp,false,false)
end
function c11200021.con2(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_SPELL) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and rc:IsSetCard(0x132)
		and Duel.IsExistingMatchingCard(c11200021.cfilter2,rp,LOCATION_GRAVE,0,1,nil,e,rp) and Duel.GetLocationCount(rp,LOCATION_MZONE)>0
end
--
function c11200021.op2(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c11200021.op2_1)
end
--
function c11200021.op2_1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsHasEffect(EFFECT_NECRO_VALLEY) then 
		Duel.NegateEffect(0)
	else
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c11200021.cfilter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		if sg:GetCount()<1 then return end
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
--
