--终末旅者 列文斯基
function c65010062.initial_effect(c)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65010062,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BE_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCondition(c65010062.drcon)
	e1:SetTarget(c65010062.drtg)
	e1:SetOperation(c65010062.drop)
	c:RegisterEffect(e1)
	--synchro
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(65010062,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,65010062)
	e2:SetCost(c65010062.cost)
	e2:SetTarget(c65010062.tg)
	e2:SetOperation(c65010062.op)
	c:RegisterEffect(e2)
end
c65010062.setname="RagnaTravellers"
function c65010062.costfil(c,e,tp)
	local lv=c:GetLevel()
	local check=0
	if Duel.IsExistingMatchingCard(c65010062.synfil,tp,LOCATION_EXTRA,0,1,nil,e,tp,lv) then check=1 end
	return c:IsType(TYPE_TUNER) and c:IsAbleToRemoveAsCost() and check==1 and c:IsLevelAbove(1)
end
function c65010062.synfil(c,e,tp,lv)
	return c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false) and c.setname=="RagnaTravellers" and c:IsType(TYPE_SYNCHRO) and c:GetLevel()==lv+4 
end
function c65010062.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c65010062.costfil,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	local g=Duel.SelectMatchingCard(tp,c65010062.costfil,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	local gc=g:GetFirst()
	local lv=gc:GetLevel()+c:GetLevel()
	e:SetLabel(lv)
	g:AddCard(c)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c65010062.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCountFromEx(tp)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c65010062.synfil2(c,e,tp,lv)
	return c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false) and c.setname=="RagnaTravellers" and c:IsType(TYPE_SYNCHRO) and c:IsLevel(lv)
end
function c65010062.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCountFromEx(tp)<=0 then return end
	local lv=e:GetLabel()
	local g=Duel.SelectMatchingCard(tp,c65010062.synfil2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,lv)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,SUMMON_TYPE_SYNCHRO,tp,tp,true,true,POS_FACEUP)
	end
end

function c65010062.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_SYNCHRO
end
function c65010062.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c65010062.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end