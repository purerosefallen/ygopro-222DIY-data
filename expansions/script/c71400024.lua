--梦之书之主
xpcall(function() require("expansions/script/c71400001") end,function() require("script/c71400001") end)
function c71400024.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,yume.YumeCheck(c),4,3,c71400024.ovfiltergen(c),aux.Stringid(71400024,0),3,c71400024.xyzop)
	c:EnableReviveLimit()
	--summon limit
	yume.AddYumeSummonLimit(c,1)
	--disable spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetCondition(c71400024.con1)
	c:RegisterEffect(e1)
	--attack cost
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ATTACK_COST)
	e2:SetCost(c71400024.cost)
	e2:SetOperation(c71400024.op)
	c:RegisterEffect(e2)
end
function c71400024.ovfiltergen(v)
	local function f(c) return c:IsFaceup() and c:IsSetCard(0x3714) end
	return function(c) return Duel.IsExistingMatchingCard(f,v:GetControler(),LOCATION_FZONE,0,1,nil) and c:IsFaceup() and c:IsSetCard(0x715) and c:IsType(TYPE_XYZ) and not c:IsCode(71400024) end
end
function c71400024.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,71400024)==0 end
	Duel.RegisterFlagEffect(tp,71400024,RESET_PHASE+PHASE_END,0,1)
end
function c71400024.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x3715)
end
function c71400024.con1(e)
	return Duel.IsExistingMatchingCard(c71400024.filter,0,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function c71400024.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.CheckRemoveOverlayCard(tp,1,0,1,REASON_COST)
end
function c71400024.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.RemoveOverlayCard(tp,1,0,1,1,REASON_COST)
end