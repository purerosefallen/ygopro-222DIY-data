--辣鸡鲶包
function c10173034.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(c10173034.xyzcon)
	e1:SetOperation(c10173034.xyzop)
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c10173034.atkval)
	c:RegisterEffect(e2)
	--Xyz Material
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10173034,0))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c10173034.xmcon)
	e3:SetTarget(c10173034.xmtg)
	e3:SetOperation(c10173034.xmop)
	c:RegisterEffect(e3)
	--battle
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_BATTLED)
	e4:SetOperation(c10173034.baop)
	c:RegisterEffect(e4)
end
function c10173034.xmcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc~=nil and bc:IsAttackAbove(c:GetAttack())
end
function c10173034.xmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ) and e:GetHandler():GetFlagEffect(10173034)==0
		and Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,TYPE_MONSTER) end
	e:GetHandler():RegisterFlagEffect(10173034,RESET_CHAIN,0,1)
end
function c10173034.xmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not c:IsType(TYPE_XYZ) then return end
	local bc,count,g,sg=c:GetBattleTarget(),4,Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_GRAVE+LOCATION_HAND,0,nil,TYPE_MONSTER)
	while count>0 and g:GetCount()>0 do
		if count<4 then
		   if not bc:IsRelateToBattle() or c:IsAttackAbove(bc:GetAttack()) or not Duel.SelectYesNo(tp,aux.Stringid(10173034,1)) then break 
		   end
		   Duel.BreakEffect()
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		sg=g:Select(tp,1,1,nil)
		g:Sub(sg)
		if sg:GetFirst():IsImmuneToEffect(e) then break end
		Duel.Overlay(c,sg)
		count=count-1
		g:Sub(sg)
	end
end
function c10173034.atkval(e,c)
	return c:GetOverlayCount()*1000
end
function c10173034.mfilter(c,xyzc)
	return c:IsFaceup() and c:IsCanBeXyzMaterial(xyzc) and not c:IsType(TYPE_TOKEN) and c:IsLevelAbove(1)
end
function c10173034.xyzfilter1(c,g,ct)
	return g:IsExists(c10173034.xyzfilter2,ct,c,c:GetOriginalLevel())
end
function c10173034.xyzfilter2(c,lv)
	return c:GetOriginalLevel()==lv
end
function c10173034.xyzcon(e,c,og,min,max)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local minc=2
	local maxc=99
	if min then
		minc=math.max(minc,min)
		maxc=max
	end
	local ct=math.max(minc-1,-ft)
	local mg=nil
	if og then
		mg=og:Filter(c10173034.mfilter,nil,c)
	else
		mg=Duel.GetMatchingGroup(c10173034.mfilter,tp,LOCATION_MZONE,0,nil,c)
	end
	return maxc>=2 and mg:IsExists(c10173034.xyzfilter1,1,nil,mg,ct)
end
function c10173034.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
	local g=nil
	if og and not min then
		g=og
	else
		local mg=nil
		if og then
			mg=og:Filter(c10173034.mfilter,nil,c)
		else
			mg=Duel.GetMatchingGroup(c10173034.mfilter,tp,LOCATION_MZONE,0,nil,c)
		end
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		local minc=2
		local maxc=99
		if min then
			minc=math.max(minc,min)
			maxc=max
		end
		local ct=math.max(minc-1,-ft)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		g=mg:FilterSelect(tp,c10173034.xyzfilter1,1,1,nil,mg,ct)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g2=mg:FilterSelect(tp,c10173034.xyzfilter2,ct,maxc-1,g:GetFirst(),g:GetFirst():GetOriginalLevel())
		g:Merge(g2)
	end
	c:SetMaterial(g)
	Duel.Overlay(c,g)
end
function c10173034.baop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local d=c:GetBattleTarget()
	if d and c:IsFaceup() and not c:IsStatus(STATUS_DESTROY_CONFIRMED) and d:IsStatus(STATUS_BATTLE_DESTROYED) then
		local e1=Effect.CreateEffect(c)
		e1:SetCode(EFFECT_SEND_REPLACE)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e1:SetTarget(c10173034.reptg)
		e1:SetOperation(c10173034.repop)
		e1:SetLabelObject(c)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		d:RegisterEffect(e1)
	end
end
function c10173034.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetDestination()==LOCATION_GRAVE and c:IsReason(REASON_BATTLE) and not c:IsImmuneToEffect(e) end
	return true
end
function c10173034.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local og=c:GetOverlayGroup()
		 if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		 end
	Duel.Overlay(e:GetLabelObject(),Group.FromCards(c))
end