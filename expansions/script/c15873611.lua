--心之怪盗团-Joker
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m=15873611
local cm=_G["c"..m]
if not rsv.PhantomThievesOfHearts then
	rsv.PhantomThievesOfHearts={}
	rsphh=rsv.PhantomThievesOfHearts
function rsphh.SetCode(c,ispersona)
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	local mt=getmetatable(c)
	local code=ispersona and "Persona" or "PhantomThievesOfHearts"
	mt.rssetcode=code
end
function rsphh.mset(c)
	return c:CheckSetCard("PhantomThievesOfHearts") and c:IsType(TYPE_MONSTER)
end
function rsphh.stset(c)
	return c:CheckSetCard("PhantomThievesOfHearts") and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function rsphh.set(c)
	return c:CheckSetCard("PhantomThievesOfHearts")
end
function rsphh.set2(c)
	return c:CheckSetCard("Persona")
end
function rsphh.stset2(c)
	return c:CheckSetCard("Persona") and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function rsphh.mset2(c)
	return c:CheckSetCard("Persona") and c:IsType(TYPE_MONSTER)
end
function rsphh.ImmueFun(c,att)
	local e1=rsef.SV_IMMUNE_EFFECT(c,rsphh.imval(att))
	return e1
end
function rsphh.imval(att)
	return function(e,re)
		return re:GetHandler():IsAttribute(att) and re:GetOwnerPlayer()~=e:GetOwnerPlayer()
	end
end
function rsphh.EndPhaseFun(c,code)
	local e1=rsef.FC(c,EVENT_PHASE+PHASE_END,nil,1)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCondition(rsphh.descon(code))
	e1:SetOperation(rsphh.desop)
	return e1
end
function rsphh.descon(code)
	return function(e,tp)
		return not Duel.IsExistingMatchingCard(rscf.FilterFaceUp(Card.IsCode,code),tp,LOCATION_ONFIELD,0,1,nil)
	end
end
function rsphh.desop(e,tp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end 
-----------
end
-----------
if cm then
function cm.initial_effect(c)
	rsphh.SetCode(c)	
	c:SetUniqueOnField(1,0,m)
	local e1=rsphh.ImmueFun(c,ATTRIBUTE_DARK)
	local e2=rsef.STO(c,EVENT_SUMMON_SUCCESS,{m,0},{1,m},"se,th",nil,nil,nil,rstg.target(rsop.list(cm.thfilter,"th",LOCATION_DECK)),cm.thop)  
	local e3=rsef.RegisterClone(c,e2,"code",EVENT_SPSUMMON_SUCCESS)
	local e4=rsef.I(c,{m,1},{1,m+100},"rm,sp","tg",LOCATION_GRAVE,nil,nil,rstg.target(cm.rmfilter,"rm",LOCATION_GRAVE,0,1,1,c),cm.spop)
end
function cm.spop(e,tp)
	local tc=rscf.GetTargetCard()
	local c=aux.ExceptThisCard(e)
	if not tc or Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)<=0 or not c  or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or rssf.SpecialSummon(c)<=0 then return end   
	local e1,e2,e3=rsef.SV_CANNOT_BE_MATERIAL(c,"syn,xyz,link",nil,nil,rsreset.est,"cd")
	local e4,e5=rsef.SV_LIMIT(c,"dis,dise",nil,nil,rsreset.est,"cd")
end
function cm.rmfilter(c)
	return c:IsAbleToRemove() and rsphh.mset(c)
end
function cm.thfilter(c)
	return c:IsAbleToHand() and rsphh.mset(c)
end
function cm.thop(e,tp)
	rsof.SelectHint(tp,"th")
	local tg=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #tg>0 then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
-----------
end