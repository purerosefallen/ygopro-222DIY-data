--破灭之永恒末日龙
function c44444082.initial_effect(c)
    --xyz summon
	aux.AddXyzProcedure(c,nil,12,5)
	c:EnableReviveLimit()
	--xyz
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetDescription(aux.Stringid(44444082,0))
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCountLimit(1,44444082+EFFECT_COUNT_CODE_DUEL)
	e1:SetCondition(c44444082.xyzcon)
	e1:SetOperation(c44444082.xyzop)
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e2)
	--summon success
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetOperation(c44444082.sumsuc)
	c:RegisterEffect(e3)
	--hand
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_HAND_LIMIT)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(1,1)
	e4:SetValue(100)
	c:RegisterEffect(e4)
	--to grave
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(44444082,1))
	e5:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DAMAGE)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetCountLimit(1)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCost(c44444082.sgcost)
	e5:SetTarget(c44444082.sgtg)
	e5:SetOperation(c44444082.sgop)
	c:RegisterEffect(e5)
end
function c44444082.xyzfilter(c)
	return c:IsLevelAbove(5)
end
function c44444082.xyzcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.GetLocationCount(tp,0x4)<=0 then return false end
	return Duel.IsExistingMatchingCard(c44444082.xyzfilter,tp,0x20,0,5,nil) 
end
function c44444082.xyzop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
	local g=Duel.SelectMatchingCard(tp,c44444082.xyzfilter,tp,0x20,0,5,5,nil)
	c:SetMaterial(g)
	Duel.Overlay(c,g)
end
function c44444082.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimitTillChainEnd(c44444082.chlimit(tp))
end
function c44444082.chlimit(p)
   return function (re,rp,tp)
	     return  p==tp 
    end
end
function c44444082.sgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,5,0x80) end
	e:GetHandler():RemoveOverlayCard(tp,5,5,0x80)
end
function c44444082.sgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0x2,0x2,1,nil)  end
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0x2,0x2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,1-tp,g:GetCount()*400)
end
function c44444082.sgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0x2,0x2,nil)
	if g:GetCount()>0 then
	Duel.SendtoGrave(g,0x80)
	local og=Duel.GetOperatedGroup()
	local ct=og:FilterCount(Card.IsLocation,nil,0x10)
	Duel.BreakEffect()
	Duel.Damage(1-tp,ct*400,0x80)
	end
end