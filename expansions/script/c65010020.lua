--虚数魔域 茜
function c65010020.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c65010020.xyzcon)
	e1:SetOperation(c65010020.xyzop)
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c65010020.imval)
	c:RegisterEffect(e2)
	--half damage
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e3:SetCondition(c65010020.rdcon)
	e3:SetOperation(c65010020.rdop)
	c:RegisterEffect(e3)
	--OSIRIS
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCost(c65010020.cost)
	e4:SetOperation(c65010020.operation)
	c:RegisterEffect(e4)
end

function c65010020.imval(e,re)
	local rc=re:GetHandler()
	return rc:IsType(TYPE_MONSTER) and rc:GetBaseAttack()<=3500 and re:IsHasType(EFFECT_TYPE_IGNITION+EFFECT_TYPE_QUICK_F+EFFECT_TYPE_QUICK_O+EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_TRIGGER_O)
end
function c65010020.rdcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and not e:GetHandler():GetOverlayGroup():IsExists(Card.IsRace,1,nil,RACE_CYBERSE)
end
function c65010020.rdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev/2)
end
function c65010020.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c65010020.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentPhase()==PHASE_DRAW or Duel.GetCurrentPhase()==PHASE_STANDBY then
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetReset(RESET_PHASE+PHASE_STANDBY,2)
	e1:SetCondition(c65010020.osicon)
	e1:SetOperation(c65010020.osiop)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	Duel.RegisterEffect(e2,tp)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	Duel.RegisterEffect(e3,tp)
	else
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetReset(RESET_PHASE+PHASE_STANDBY)
	e1:SetCondition(c65010020.osicon)
	e1:SetOperation(c65010020.osiop)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	Duel.RegisterEffect(e2,tp)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	Duel.RegisterEffect(e3,tp)
	end
end
function c65010020.atkfilter(c,e,tp)
	return c:IsControler(tp) 
end
function c65010020.osicon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c65010020.atkfilter,1,nil,e,1-tp) and e:GetHandler():IsLocation(LOCATION_MZONE)
end
function c65010020.osiop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c65010020.atkfilter,nil,e,1-tp)
	local dg=Group.CreateGroup()
	local c=e:GetHandler()
	local tc=g:GetFirst()
	while tc do
		local preatk=tc:GetAttack()
		local predef=tc:GetDefense()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-2500)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		e2:SetValue(-2500)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		if (preatk~=0 and tc:GetAttack()==0) or (predef~=0 and tc:GetDefense()==0) then dg:AddCard(tc) end
		tc=g:GetNext()
	end
	Duel.Destroy(dg,REASON_EFFECT)
end

function c65010020.mfilter(c,xyzc)
	return (c:IsFaceup() or not c:IsOnField()) and c:IsCanBeXyzMaterial(xyzc) and c:GetLevel()>0 
end
function c65010020.xyzfilter1(c,g)
	return c:IsLevel(10) and g:IsExists(c65010020.xyzfilter2,1,c,c:GetAttribute())
end
function c65010020.xyzfilter2(c,at)
	return c:IsLevel(10) and c:GetAttribute()~=at  
end
function c65010020.xyzfilter3(c,g)
	local att=0
	local tc=g:GetFirst()
	while tc do
		if c:GetAttribute()==tc:GetAttribute() then att=1 end
		tc=g:GetNext()
	end
	return att==0 and c:IsLevel(10)
end
function c65010020.xyzcon(e,c,og,min,max)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local minc,maxc=2,2
	if min then
		minc=math.max(minc,min)
		maxc=max
	end
	local mg=nil
	if og then
		mg=og:Filter(c65010020.mfilter,nil,c)
	else
		mg=Duel.GetMatchingGroup(c65010020.mfilter,tp,LOCATION_MZONE,0,nil,c)
	end
	return mg:IsExists(c65010020.xyzfilter1,1,nil,mg)
end
function c65010020.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
	local g=nil
	if og and not min then
		g=og
	else
		local mg=nil
		if og then
			mg=og:Filter(c65010020.mfilter,nil,c)
		else
			mg=Duel.GetMatchingGroup(c65010020.mfilter,tp,LOCATION_MZONE,0,nil,c)
		end
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		local minc,maxc=2,2
		if min then
			minc=math.max(minc,min)
			maxc=max
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		g=mg:FilterSelect(tp,c65010020.xyzfilter1,1,1,nil,mg)
		local gr=0
		while gr==0 do
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
			local g2=mg:FilterSelect(tp,c65010020.xyzfilter3,1,1,nil,g)
			g:Merge(g2)
			if not Duel.IsExistingMatchingCard(c65010020.xyzfilter3,tp,LOCATION_MZONE,0,1,nil,g) or not Duel.SelectYesNo(tp,aux.Stringid(65010020,0)) then gr=1 end  
		end
	end
	c:SetMaterial(g)
	Duel.Overlay(c,g)
end