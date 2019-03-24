--露文律的龙夫 瑟
--script by Real_Scl
local m=21400043
local cm=_G["c"..m]
function c21400043.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--toextra
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(21400043,0))
	e0:SetCategory(CATEGORY_TOEXTRA)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_PZONE)
	e0:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e0:SetCountLimit(1)
	e0:SetTarget(c21400043.tetg)
	e0:SetOperation(c21400043.teop)
	c:RegisterEffect(e0)

	--summon with s/t
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_ADD_EXTRA_TRIBUTE)
	e1:SetTargetRange(LOCATION_SZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_SPELL+TYPE_TRAP))
	e1:SetValue(POS_FACEUP_ATTACK)
	c:RegisterEffect(e1)

	--yishizhaohuan
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21400043,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE+LOCATION_GRAVE+LOCATION_HAND)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,21400043)
	e2:SetCost(c21400043.cost)
	e2:SetTarget(c21400043.target)
	e2:SetOperation(c21400043.op)
	c:RegisterEffect(e2)
	
	--Search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(21400043,2))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_RELEASE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCost(c21400043.thcost)
	e3:SetTarget(c21400043.thtg)
	e3:SetOperation(c21400043.thop)
	c:RegisterEffect(e3)

end


function c21400043.tefilter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and not c:IsForbidden() and c:IsRace(RACE_DRAGON)
end

function c21400043.tetg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_ONFIELD) and chkc:IsControler(tp) and c21400043.tefilter(chkc) end

	if chk==0 then return Duel.IsExistingTarget(c21400043.tefilter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0  and Duel.IsPlayerCanSpecialSummonMonster(tp,21499999,0xc21,0x4011,0,0,3,RACE_DRAGON,ATTRIBUTE_WATER) end
--  Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(21400043,1))

	local g=Duel.SelectTarget(tp,c21400043.tefilter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,1,99,nil)

	local cnt=g:GetCount()
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,g,cnt,0,0)
	local cntfg=g:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)
	if cntfg>0 then
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,cntfg,0,0)
	end
end

function c21400043.atkfl(c)
	return c:GetAttack()>=0
end
function c21400043.deffl(c)
	return c:GetDefense()>=0
end

function c21400043.teop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local cntrn=Duel.SendtoExtraP(g,tp,REASON_EFFECT)
	if cntrn<=0 then return end


	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,21499999,0xc21,0x4011,0,0,3,RACE_DRAGON,ATTRIBUTE_WATER) then return end

	local atkn=g:Filter(c21400043.atkfl,nil):GetSum(Card.GetAttack)
	local defn=g:Filter(c21400043.deffl,nil):GetSum(Card.GetDefense)


	local token=Duel.CreateToken(tp,21499999)
	if Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(atkn)
		token:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetValue(defn)
		token:RegisterEffect(e2,true)   
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_NO_BATTLE_DAMAGE)
		token:RegisterEffect(e3,true)
		local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
		e4:SetValue(1)
		token:RegisterEffect(e4)   
	end
	Duel.SpecialSummonComplete()

end

----------------------------------------------------------------------------------

function c21400043.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SendtoExtraP(e:GetHandler(),tp,REASON_EFFECT)
end

function cm.spfilter(c,e,tp,mc,rg0)
	return bit.band(c:GetOriginalType(),0x81)==0x81 and (not c.mat_filter or c.mat_filter(mc) or (rg0 and rg0:IsContains(c)))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
		and (mc:IsCanBeRitualMaterial(c) or (rg0 and rg0:IsContains(c))) and (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and ((c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,mc)>0) or (not c:IsLocation(LOCATION_EXTRA) and Duel.GetMZoneCount(tp,mc,tp)>0)) and cm.lvfilter(c)>0 and c:IsSetCard(0xc21)
end
function cm.lvfilter(c)
	local lv=c:GetLevel()
	if not c:IsLocation(LOCATION_HAND) then
	   lv=c:GetOriginalLevel()
	end
	return lv
end
function cm.rfilter(c,mc,notbool)
	local lv=cm.lvfilter(c)
	local mlv=mc:GetRitualLevel(c)
	local lv=c:GetLevel()
	return lv==bit.band(mlv,0xffff) or lv==bit.rshift(mlv,16) or (mc:IsLevelAbove(lv) and notbool==false)
end
function cm.filter(c,e,tp)
	local sg1=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_HAND+LOCATION_PZONE+LOCATION_EXTRA,0,c,e,tp,c)
	return sg1:IsExists(cm.rfilter,1,nil,c,false)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetRitualMaterial(tp)
	if chk==0 then return mg:IsExists(cm.filter,1,e:GetHandler(),e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_PZONE+LOCATION_EXTRA)
end
function cm.rfilter2(c,sg,mlv)
	local lv1=sg:GetSum(cm.lvfilter)
	local lv2=cm.lvfilter(c)
	return lv1+lv2<=mlv
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetRitualMaterial(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local mat=mg:FilterSelect(tp,cm.filter,1,1,nil,e,tp)
	local mc=mat:GetFirst()
	if not mc then return end
	local sg=Group.CreateGroup()
	local rg0=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_HAND+LOCATION_PZONE+LOCATION_EXTRA,0,mc,e,tp,mc)
	local tf=false 
	repeat
		local rg=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_HAND+LOCATION_PZONE+LOCATION_EXTRA,0,mc,e,tp,mc,rg0)
		if rg:GetCount()<=0 then break end
		local tc=nil
		if sg:GetCount()<=0 then
		   Duel.ReleaseRitualMaterial(mat)
		   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		   tc=rg:Select(tp,1,1,nil):GetFirst()
		   if cm.rfilter(tc,mc,true) and (not cm.rfilter2(tc,sg,mc:GetLevel()) or ( mc:GetLevel()~=mc:GetRitualLevel(tc) and Duel.SelectYesNo(tp,aux.Stringid(m,3)))) then tf=true end
		else
		   if Duel.IsPlayerAffectedByEffect(tp,59822133) then break end
		   local sg2=rg:Filter(cm.rfilter2,nil,sg,mc:GetLevel()) 
		   if sg2:GetCount()<=0 then break end
		   if sg:GetCount()>0 and not Duel.SelectYesNo(tp,aux.Stringid(m,4)) then break end
		   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		   tc=sg2:Select(tp,1,1,nil):GetFirst()
		end
		if sg:GetCount()==1 then
		   Duel.BreakEffect()
		end
		Duel.SpecialSummonStep(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		sg:AddCard(tc)
	until tf
	if sg:GetCount()>0 then
	   for tc in aux.Next(sg) do
		   tc:SetMaterial(mat)
		   tc:CompleteProcedure()
	   end
	   Duel.SpecialSummonComplete()
	end
end

----------------------------------------------------------------------------------

function c21400043.counterfilter(c)
	return c:GetSummonLocation()~=LOCATION_DECK or c:GetSummonLocation()~= LOCATION_GRAVE
end

function c21400043.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(c21400043,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c21400043.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c21400043.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_DECK) or c:IsLocation(LOCATION_GRAVE)
end

function c21400043.thfilter(c)
	return c:IsAbleToGrave()
end
function c21400043.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21400043.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c21400043.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c21400043.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,nil,REASON_EFFECT)
	end
end
